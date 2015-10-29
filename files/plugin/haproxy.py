# haproxy-collectd-plugin - haproxy.py
#
# Author: Michael Leinartas
# Description: This is a collectd plugin which runs under the Python plugin to
# collect metrics from haproxy.
# Plugin structure and logging func taken from
# https://github.com/phrawzty/rabbitmq-collectd-plugin
#
# Modified by "Warren Turkal" <wt@signalfuse.com>

import cStringIO as StringIO
import socket
import csv

import collectd

PLUGIN_NAME = 'haproxy'
RECV_SIZE = 1024
METRIC_TYPES = {
    'MaxConn': ('max_connections', 'gauge'),
    'CumConns': ('connections', 'counter'),
    'CumReq': ('requests', 'counter'),
    'MaxConnRate': ('max_connection_rate', 'gauge'),
    'MaxSessRate': ('max_session_rate', 'gauge'),
    'MaxSslConns': ('max_ssl_connections', 'gauge'),
    'CumSslConns': ('ssl_connections', 'counter'),
    'MaxSslConns': ('max_ssl_connections', 'gauge'),
    'MaxPipes': ('max_pipes', 'gauge'),
    'Idle_pct': ('idle_pct', 'gauge'),
    'Tasks': ('tasks', 'gauge'),
    'Run_queue': ('run_queue', 'gauge'),
    'PipesUsed': ('pipes_used', 'gauge'),
    'PipesFree': ('pipes_free', 'gauge'),
    'Uptime_sec': ('uptime_seconds', 'counter'),
    'bin': ('bytes_in', 'counter'),
    'bout': ('bytes_out', 'counter'),
    'chkfail': ('failed_checks', 'counter'),
    'downtime': ('downtime', 'counter'),
    'dresp': ('denied_response', 'counter'),
    'dreq': ('denied_request', 'counter'),
    'econ': ('error_connection', 'counter'),
    'ereq': ('error_request', 'counter'),
    'eresp': ('error_response', 'counter'),
    'hrsp_1xx': ('response_1xx', 'counter'),
    'hrsp_2xx': ('response_2xx', 'counter'),
    'hrsp_3xx': ('response_3xx', 'counter'),
    'hrsp_4xx': ('response_4xx', 'counter'),
    'hrsp_5xx': ('response_5xx', 'counter'),
    'hrsp_other': ('response_other', 'counter'),
    'qcur': ('queue_current', 'gauge'),
    'rate': ('session_rate', 'gauge'),
    'req_rate': ('request_rate', 'gauge'),
    'stot': ('session_total', 'counter'),
    'scur': ('session_current', 'gauge'),
    'wredis': ('redistributed', 'counter'),
    'wretr': ('retries', 'counter'),
}

METRIC_DELIM = '.'  # for the frontend/backend stats

DEFAULT_SOCKET = '/var/lib/haproxy/stats'
VERBOSE_LOGGING = False
HAPROXY_SOCKET = None


class Logger(object):
    def error(self, msg):
        collectd.error('{name}: {msg}'.format(name=PLUGIN_NAME, msg=msg))

    def notice(self, msg):
        collectd.warning('{name}: {msg}'.format(name=PLUGIN_NAME, msg=msg))

    def warning(self, msg):
        collectd.notice('{name}: {msg}'.format(name=PLUGIN_NAME, msg=msg))

    def verbose(self, msg):
        if VERBOSE_LOGGING:
            collectd.info('{name}: {msg}'.format(name=PLUGIN_NAME, msg=msg))

log = Logger()


class HAProxySocket(object):
    def __init__(self, socket_file=DEFAULT_SOCKET):
        self.socket_file = socket_file

    def connect(self):
        stat_sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        stat_sock.connect(self.socket_file)
        return stat_sock

    def communicate(self, command):
        '''Get response from single command.

        Args:
            command: string command to send to haproxy stat socket

        Returns:
            a string of the response data
        '''
        if not command.endswith('\n'):
            command += '\n'
        stat_sock = self.connect()
        stat_sock.sendall(command)
        result_buf = StringIO.StringIO()
        buf = stat_sock.recv(RECV_SIZE)
        while buf:
            result_buf.write(buf)
            buf = stat_sock.recv(RECV_SIZE)
        stat_sock.close()
        return result_buf.getvalue()

    def get_server_info(self):
        result = {}
        output = self.communicate('show info')
        for line in output.splitlines():
            try:
                key, val = line.split(':', 1)
            except ValueError:
                continue
            result[key.strip()] = val.strip()
        return result

    def get_server_stats(self):
        output = self.communicate('show stat')
        #sanitize and make a list of lines
        output = output.lstrip('# ').strip()
        output = [l.strip(',') for l in output.splitlines()]
        csvreader = csv.DictReader(output)
        result = [d.copy() for d in csvreader]
        return result


def get_stats():
    if HAPROXY_SOCKET is None:
        return

    stats = {}
    haproxy = HAProxySocket(HAPROXY_SOCKET)

    try:
        server_info = haproxy.get_server_info()
        server_stats = haproxy.get_server_stats()
    except socket.error:
        log.warning(
            'status err Unable to connect to HAProxy socket at %s' %
            HAPROXY_SOCKET)
        return stats

    for key, val in server_info.iteritems():
        try:
            stats[key] = int(val)
        except (TypeError, ValueError):
            pass

    ignored_svnames = set(['BACKEND'])
    for statdict in server_stats:
        if statdict['svname'] in ignored_svnames:
            continue
        for key, val in statdict.items():
            metricname = METRIC_DELIM.join(
                [statdict['svname'].lower(), statdict['pxname'].lower(), key])
            try:
                stats[metricname] = int(val)
            except (TypeError, ValueError):
                pass
    return stats


def configure_callback(conf):
    global HAPROXY_SOCKET, VERBOSE_LOGGING
    HAPROXY_SOCKET = DEFAULT_SOCKET
    VERBOSE_LOGGING = False

    for node in conf.children:
        if node.key == "Socket":
            HAPROXY_SOCKET = node.values[0]
        elif node.key == "Verbose":
            VERBOSE_LOGGING = bool(node.values[0])
        else:
            log.warning('Unknown config key: %s' % node.key)


def read_callback():
    log.verbose('beginning read_callback')
    info = get_stats()

    if not info:
        log.warning('%s: No data received' % PLUGIN_NAME)
        return

    for key, value in info.iteritems():
        key_prefix = ''
        key_root = key
        if not value in METRIC_TYPES:
            try:
                key_prefix, key_root = key.rsplit(METRIC_DELIM, 1)
            except ValueError:
                pass
        if not key_root in METRIC_TYPES:
            continue

        key_root, val_type = METRIC_TYPES[key_root]
        if key_prefix == '':
            key_name = key_root
        else:
            key_name = METRIC_DELIM.join([key_prefix, key_root])
        log.verbose('{0}: {1}'.format(key_name, value))
        val = collectd.Values(plugin=PLUGIN_NAME, type=val_type)
        val.type_instance = key_name
        val.values = [value]
        val.meta = {'bug_workaround': True}
        val.dispatch()

collectd.register_config(configure_callback)
collectd.register_read(read_callback)
