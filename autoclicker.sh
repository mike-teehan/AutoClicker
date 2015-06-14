#!/bin/bash

# check the state of the scroll lock key and return true if it is on, false if not
function checkScrollLock {
	SLS=$(xset q | grep LED | awk '{ print $10 }' | sed 's/^0*//')
	if [ "${SLS}" == "" ]; then
		SLS=0
	fi
	if (((${SLS} & 4) == 4)); then
		return 0	#true
	else
		return 1	#false
	fi
}

# check that xdotool is installed and exit if it isn't
XDOINSTALLED=$(which xdotool | wc -l)
if [ $XDOINSTALLED -eq 0 ]; then
	echo "ALERT: xdotool required, but not found!"
	exit
fi

# hackey for scroll lock
XMM=$(xmodmap -pm | grep Scroll_Lock | wc -l)
if [ $XMM -ne 1 ]; then
	echo "Adding Scroll Lock hackery..."
	$(xmodmap -e "add mod3 = Scroll_Lock")
fi

ACTIVE=false

# just loop forever (quit with ctrl-c)
while true; do
	if checkScrollLock; then
		if ! $ACTIVE; then
			ACTIVE=true
			XDOINFO=$(xdotool getmouselocation)
			XPOS=$(echo "${XDOINFO}" | awk '{ print $1 }' | cut -b3-)
			YPOS=$(echo "${XDOINFO}" | awk '{ print $2 }' | cut -b3-)
		fi
		xdotool mousemove --sync $XPOS $YPOS click 1 mousemove --sync restore
	else
		if $ACTIVE; then
			ACTIVE=false
		fi
	fi
	sleep .1
done
