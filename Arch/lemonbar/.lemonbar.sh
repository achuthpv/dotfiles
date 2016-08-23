CD="$HOME/.Xresources"

#Colors
BG=$(cat ${CD} | grep -i background | tail -c 8)
FG=$(cat ${CD} | grep -i foreground | tail -c 8)

#Panel
PW=1280
PH=20
PX=0
PY=0

#Fonts
FONT1="-*-tamsyn-medium-r-normal-*-12-*-*-*-*-*-*-1"
FONT2="-wuncon-siji-medium-r-normal--10-100-75-75-c-80-iso10646-1"

herbstluftwmworkspaces()
{
	TAGS=( $(herbstclient tag_status $monitor) )
	#unset TAGS[${#TAGS[@]}-1] #Remove last tag
	for i in "${TAGS[@]}" ; do
		case ${i:0:1} in
			'#') #current tag
				echo -n "%{B#E3295B} %{F#000000}"
				;;
			'+') #active on other monitor
				echo -n "%{B#8fd9d5} %{F$FG}"
				;;
			':') #not sure
				echo -n ""
				;;
			'!') #urgent
				echo -n ""
				;;
			*) #everything else
				echo -n "%{B$BG} %{F$FG}"
				;;
		esac
		echo -n "  ${i:1}   " | tr '[:lower:]' '[:upper:] '
		echo -n "%{B$BG} %{F$FG}"
	done

}


_time()
{
	TIME=$(date +'%H:%M')

	echo -e -n "\ue017 $TIME"
}

pac()
{
	PAC=$(checkupdates | wc -l)
	echo -e -n "\ue00f $PAC"
}

memory()
{
	MEMORYUSED=$(free -h | grep Mem: | awk '{print $3}')
	echo -e -n "\ue020 $MEMORYUSED"
}

mpd_song()
{
	ARTIST=$(mpc -f %artist% current)
	SONG=$(mpc -f %title% current)
	if [[ -n $ARTIST ]] || [[ -n $SONG ]]; then
		echo -e -n "\ue04d $ARTIST - $SONG"
	else
		echo -n "No music playing"
	fi
}

volume()
{
        ALSA_VOLUME=$(amixer get Master | grep 'Mono: Playback' | grep -o '...%' | sed 's/\[//' | sed 's/%//' | sed 's/ //')
        ALSA_STATE=$(amixer get Master | grep 'Mono: Playback' | grep -o '\[on]')

        if [ $ALSA_STATE ]
        then
        if [ $ALSA_VOLUME -ge 70 ]
        then
                echo -e -n '\ue05d' $ALSA_VOLUME
        fi
        if [ $ALSA_VOLUME -gt 0 -a $ALSA_VOLUME -lt 70 ]
        then
                echo -e -n  '\ue050' $ALSA_VOLUME
        fi
        if [ $ALSA_VOLUME -eq 0 ]
        then
                echo -e -n '\ue04e' $ALSA_VOLUME
        fi
        else
                echo -e -n  '\ue04f' $ALSA_VOLUME
        fi
}

