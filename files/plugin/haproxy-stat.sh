 #!/bin/sh
 
 sock='/var/run/haproxy-stat'
 host="${COLLECTD_HOSTNAME}"
 pause="${COLLECTD_INTERVAL:-10}"
 
 while getopts "h:p:s:" c; do
        case $c in
                h)      host=$OPTARG;;
                p)      pause=$OPTARG;;
                s)      sock=$OPTARG;;
                *)      echo "Usage: $0 [-h <hostname>] [-p <seconds>] [-s <sockfile>]";;
        esac
 done
 
 while [ $? -eq 0 ]; do
        time="$(date +%s)"
        echo 'show stat' | socat - UNIX-CLIENT:$sock \
        |while IFS=',' read pxname svname qcur qmax scur smax slim stot bin bout dreq dresp ereq econ eresp wretr wredis status weight act bck chkfail chdown lastchg downtime qlimit pid iid sid throttle lbtot tracked type rate rate_lim rate_max check_status check_code check_duration hrsp_1xx hrsp_2xx hrsp_3xx hrsp_4xx  hrsp_5xx hrsp_other hanafail req_rate req_rate_max req_tot cli_abrt srv_abrt; do
 
                [ "$svname" != 'web01' ] && continue
                echo "PUTVAL $host/haproxy/haproxy_backend-$pxname $time:${stot:-0}:${econ:-0}:${eresp:-0}"
        done
        sleep $pause
 done

