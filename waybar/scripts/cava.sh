#!/bin/sh
bar="▁▂▃▄▅▆▇█"
dict="s/;//g"
bar_length=${#bar}

for ((i = 0; i < bar_length; i++)); do
    dict+=";s/$i/${bar:$i:1}/g"
done

config_file="$HOME/.config/cava/cava.conf"
cat >"$config_file" <<EOF
[general]
bars = 15

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF
pkill -f "cava -p $config_file"
cava -p "$config_file"   | sed -u "$dict"

