#!/usr/bin/env bash
set -e

# Check if service has been disabled through the DISABLED_SERVICES environment variable.

if [[ ",$(echo -e "${DISABLED_SERVICES}" | tr -d '[:space:]')," = *",$BALENA_SERVICE_NAME,"* ]]; then
        echo "$BALENA_SERVICE_NAME is manually disabled."
        sleep infinity
fi
# Verify that all the required varibles are set before starting up the application.

echo "Verifying settings..."
echo " "
sleep 2

missing_variables=false

# Begin defining all the required configuration variables.

[ -z "$LAT" ] && echo "Receiver latitude is missing, will abort startup." && missing_variables=true || echo "Receiver latitude is set: $LAT"
[ -z "$LON" ] && echo "Receiver longitude is missing, will abort startup." && missing_variables=true || echo "Receiver longitude is set: $LON"
[ -z "$ALT" ] && echo "Receiver altitude is missing, will abort startup." && missing_variables=true || echo "Receiver altitude is set: $ALT"
[ -z "$OGN_CALLSIGN" ] && echo "Receiver callsign is not set, will abort startup." && missing_variables=true || echo "Receiver callsign is set: $OGN_CALLSIGN"

if [ -z "$OGN_DEVICE" ]; then
        echo "OGN device not set. Using default device."
        export OGN_DEVICE_TPL="Device = 0"
else
        echo "RTLSDR device set. Using serial number: $OGN_DEVICE"
        export OGN_DEVICE_TPL="DeviceSerial = \"${OGN_DEVICE}\""
fi

if [ "$OGN_ADSB_ENABLED" = "true" ]; then
        echo "OGN ADS-B feeding is enabled."
        export OGN_ADSB_ENABLED_TPL=""
else
        echo "OGN ADS-B feeding is disabled."
        export OGN_ADSB_ENABLED_TPL="#"
fi

if [ "$OGN_OPENSKY_ENABLED" = "true" ]; then
        echo "OpenSky Network feeding is enabled."
        export OGN_OPENSKY_ENABLED_TPL=""
else
        echo "OpenSky Network feeding is disabled."
        export OGN_OPENSKY_ENABLED_TPL="#"
fi

# End defining all the required configuration variables.

echo " "

if [ "$missing_variables" = true ]
then
        echo "Settings missing, aborting..."
        echo " "
        sleep infinity
fi

echo "Settings verified, proceeding with startup."
echo " "

# Variables are verified – continue with startup procedure.

# Configure receiver according to environment variables.
envsubst < /rtlsdr-ogn/ogn.conf.tpl> /rtlsdr-ogn/ogn.conf

/usr/bin/procServ -k ^X --killsig 15 -x ^C -i ^D -f -c /rtlsdr-ogn 50000 ./ogn-rf ogn.conf 2>&1 | stdbuf -o0 sed --unbuffered '/^$/d' | awk -W interactive '{print "[ogn-rf]    "  $0}' &
/usr/bin/procServ -k ^X --killsig 15 -x ^C -i ^D -f -c /rtlsdr-ogn 50001 ./ogn-decode ogn.conf 2>&1 | stdbuf -o0 sed --unbuffered '/^$/d' | awk -W interactive '{print "[ogn-decode]    "  $0}' &

# Wait for any services to exit.
wait -n
