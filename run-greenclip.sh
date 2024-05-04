#!/bin/bash

if pgrep -x "greenclip" > /dev/null
then
    killall greenclip
fi

greenclip daemon >/dev/null

