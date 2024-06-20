#!/usr/bin/env bash
set -e

# Check if service has been disabled through the DISABLED_SERVICES environment variable.

if [[ ",$(echo -e "${DISABLED_SERVICES}" | tr -d '[:space:]')," = *",$BALENA_SERVICE_NAME,"* ]]; then
        echo "$BALENA_SERVICE_NAME is manually disabled."
        sleep infinity
fi

# Use environment variables to write a valid configuration file (crashes with detailled error message on invalid environment variable(s)).
python3 env2conf.py > /rtlsdr-ogn/ogn.conf

# Start both processes 'ogn-rf' and 'ogn-decode'
/usr/bin/procServ -k ^X --killsig 15 -x ^C -i ^D -f -c /rtlsdr-ogn 50000 ./ogn-rf ogn.conf 2>&1 | stdbuf -o0 sed --unbuffered '/^$/d' | awk -W interactive '{print "[ogn-rf]    "  $0}' &
/usr/bin/procServ -k ^X --killsig 15 -x ^C -i ^D -f -c /rtlsdr-ogn 50001 ./ogn-decode ogn.conf 2>&1 | stdbuf -o0 sed --unbuffered '/^$/d' | awk -W interactive '{print "[ogn-decode]    "  $0}' &

# Wait for any services to exit.
wait -n
