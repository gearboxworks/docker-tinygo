#!/bin/bash
# Created on 2021-04-27T13:54:17+1000, using template:tinygo.sh.tmpl and json:gearbox.json

test -f /etc/gearbox/bin/colors.sh && . /etc/gearbox/bin/colors.sh

c_ok "Started."

c_ok "Installing packages."
APKBIN="$(which apk)"
if [ "${APKBIN}" != "" ]
then
	if [ -f /etc/gearbox/build/tinygo.apks ]
	then
		APKS="$(cat /etc/gearbox/build/tinygo.apks)"
		${APKBIN} update && ${APKBIN} add --no-cache --virtual gearbox ${APKS}; checkExit
	fi
fi

APTBIN="$(which apt-get)"
if [ "${APTBIN}" != "" ]
then
	if [ -f /etc/gearbox/build/tinygo.apt ]
	then
		DEBS="$(cat /etc/gearbox/build/tinygo.apt)"
		${APTBIN} update && ${APTBIN} install ${DEBS}; checkExit
	fi
fi


if [ -f /etc/gearbox/build/tinygo.env ]
then
	. /etc/gearbox/build/tinygo.env
fi

if [ ! -d /usr/local/bin ]
then
	mkdir -p /usr/local/bin; checkExit
fi


c_ok "Generate installed file list"
c_ok "####################"
if [ "${APKBIN}" != "" ]
then
	apk info -v -R gearbox | sed 's/gearbox://' | xargs apk info -L | awk '/bin\//{print"/"$1}'
fi
c_ok "####################"


c_ok "Finished."