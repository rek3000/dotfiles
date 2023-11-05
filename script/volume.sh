function get_volume {
  wpctl get-volume @DEFAULT_SINK@ | awk '{print $2}' | awk -F '.' '{print $2}'
}

function is_mute {
  status=$(wpctl status -k | grep 'ALC3234 Analog' | awk '{print $8}' | head -n1 | sed "s/]//")
    
}

function send_notification {
    volume=`get_volume`
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq -s "─" $(($volume/ 2)) | sed 's/[0-9]//g')
    # Send the notification
    dunstify -i audio-volume-muted-blocking -t 500 -r 2593 -u normal "    $bar"
}

case $1 in
    up)
	# Set the volume on (if it was muted)
	wpctl set-mute @DEFAULT_SINK@ 0 > /dev/null
	# Up the volume (+ 5%)
	wpctl set-volume @DEFAULT_SINK@ 2%+ > /dev/null
	send_notification
	;;
    down)
	wpctl set-mute @DEFAULT_SINK@ 0 > /dev/null
	wpctl set-volume @DEFAULT_SINK@ 2%- > /dev/null
	send_notification
	;;
    mute)
    	# Toggle mute
	wpctl set-mute @DEFAULT_SINK@ toggle > /dev/null
	if  is_mute ; then
	    dunstify -i audio-volume-muted -t 500 -r 2593 -u normal "Mute"
	else
	    send_notification
	fi
	;;
esac
