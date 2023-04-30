#!/bin/sh

readonly G_LOG_I='[INFO]'
readonly G_LOG_W='[WARN]'
readonly G_LOG_E='[ERROR]'

main() {
    launch_xvfb
    launch_window_manager
}

launch_xvfb() {
    export DISPLAY=${XVFB_DISPLAY:-:1}

    local resolution=${XVFB_RESOLUTION:-1280x1024x24}
    local screen=${XVFB_SCREEN:-0}
    local timeout=${XVFB_TIMEOUT:-5}

    Xvfb ${DISPLAY} -screen ${screen} ${resolution} &

    local loopCount=0

    until xdpyinfo -display ${DISPLAY} > /dev/null 2>&1
    do
        loopCount=$((loopCount+1))
        sleep 1
        if [ ${loopCount} -gt ${timeout} ]
        then
            echo "${G_LOG_E} Xvfb failed to start."
            exit 1
        fi
    done
}

launch_window_manager() {
    local timeout=${XVFB_TIMEOUT:-5}

    fluxbox &

    local loopCount=0

    until wmctrl -m > /dev/null 2>&1
    do
        loopCount=$((loopCount+1))
        sleep 1
        if [ ${loopCount} -gt ${timeout} ]
        then
            echo "${G_LOG_E} fluxbox failed to start."
            exit 1
        fi
    done
}

main
if [ -z "${AWS_LAMBDA_RUNTIME_API}" ]; then 
  exec /usr/local/bin/aws-lambda-rie /usr/bin/npx aws-lambda-ric $1
else
  exec /usr/bin/npx aws-lambda-ric $1
fi
