#!/bin/bash

# hackey for scroll lock
XMM=$(xmodmap -pm | grep Scroll_Lock | wc -l)
if [ $XMM -ne 1 ]; then
	echo "Adding Scroll Lock hackery..."
	$(xmodmap -e "add mod3 = Scroll_Lock")
fi

XDOINFO=$(xdotool getmouselocation)
XPOS=$(echo "${XDOINFO}" | awk '{ print $1 }' | cut -b3-)
YPOS=$(echo "${XDOINFO}" | awk '{ print $2 }' | cut -b3-)
while true; do
	SLS=$(xset q | grep LED | awk '{ print $10 }' | sed 's/^0*//')
	if [ "${SLS}" == "" ]; then
		SLS=0
	fi
	if (((${SLS} & 4) == 4)); then
		xdotool mousemove --sync $XPOS $YPOS click 1 mousemove --sync restore
	fi
	sleep .1
done
