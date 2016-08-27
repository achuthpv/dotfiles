#!/bin/sh

#-------------------------------# 
#  ╻ ╻╻┏┓╻╻╺┳╸┏━┓┏━╸            #
#  ┏╋┛┃┃┗┫┃ ┃ ┣┳┛┃              #
# ╹╹ ╹╹╹ ╹╹ ╹ ╹┗╸┗━╸            #
# by Morgareth                  #
# no login manager since forever#
#-------------------------------#

##----------------------------------------------------------------------------##
## Launch dbus 
##----------------------------------------------------------------------------##

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

##----------------------------------------------------------------------------##
## Locales
##----------------------------------------------------------------------------##

export LANG=pt_BR.UTF-8
export LC_MESSAGES=pt_BR.UTF-8
export MM_CHARSET=UTF-8

##----------------------------------------------------------------------------##
## Mpd autostart 
##----------------------------------------------------------------------------##

[ !  -s ~/.config/mpd/pid ] && mpd


##----------------------------------------------------------------------------##
## Update Xresources 
##----------------------------------------------------------------------------##

[[ -f ~/.Xresources ]] && xrdb -merge "${HOME}/.Xresources"

##----------------------------------------------------------------------------##
## My fonts   
##----------------------------------------------------------------------------##

xset +fp ~/.fonts
xset +fp /usr/share/fonts/local 
xset fp rehash
xset -dpms
xset s off

##----------------------------------------------------------------------------##
## General settings 
##----------------------------------------------------------------------------##
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
xsetroot -cursor_name left_ptr&

##----------------------------------------------------------------------------##
## Wallpapers 
##----------------------------------------------------------------------------##

nitrogen --restore &

##----------------------------------------------------------------------------------------------------------------------##
## Daemon
##----------------------------------------------------------------------------------------------------------------------##

devmon --exec-on-video "notify-send '%f mounted' 'Launching mpv...' -i mpv & mpc pause & mpv -vo opengl-hq dvdnav://menu"\
	--exec-on-drive "thunar %d"\
	--exec-on-disc "thunar %d"\
--exec-on-unmount "notify-send '%f' 'The device was successfully unmounted.' -i eject" &

dunst &
compton --config ~/.config/compton.conf  &
udiskie &
numlockx &

##----------------------------------------------------------------------------##
## startx
##----------------------------------------------------------------------------##

_start_session() {
  session=${1:-xmonad}
  case $session in
      awesome           ) exec awesome;;
      bspwm             ) exec bspwm;;
      xmonad            ) exec xmonad;;
      dwm               ) exec dwm;;
      bspwm             ) exec bspwm;;
      2bwm              ) exec 2bwm ;;
      i3|i3wm           ) exec i3;;
      mate              ) exec mate-session;;
      openbox           ) exec openbox-session;;
      xfce4             ) exec startxfce4;;
      # No known session, try to run it as command
      *) exec "$1";;
  esac
}
_start_session "$@"