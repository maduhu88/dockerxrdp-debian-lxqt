FROM debian
RUN dpkg --add-architecture i386
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install wine qemu-kvm *zenhei* xz-utils dbus-x11 curl firefox-esr gnome-system-monitor mate-system-monitor  git xserver-xorg x11-apps sudo tightvncserver wget   -y

# LXQT desktop
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends lxqt-core qtwayland5 xfwm4 && \
    apt install -y --no-install-recommends featherpad lxqt-about lxqt-config lxqt-qtplugin pavucontrol-qt qlipper qterminal

# config lxqt
RUN mkdir -p /etc/skel/.config/lxqt && \
    echo '[General]\n\
__userfile__=true\n\
icon_theme=Adwaita\n\
single_click_activate=false\n\
theme=ambiance\n\
tool_button_style=ToolButtonTextBesideIcon\n\
\n\
[Qt]\n\
doubleClickInterval=400\n\
font="Sans,11,-1,5,50,0,0,0,0,0"\n\
style=Fusion\n\
wheelScrollLines=3\n\
' >/etc/skel/.config/lxqt/lxqt.conf && \
    echo '[General]\n\
__userfile__=true\n\
[Environment]\n\
TERM=qterminal\n\
' >/etc/skel/.config/lxqt/session.conf

# config pcmanfm-qt
RUN mkdir -p /etc/skel/.config/pcmanfm-qt/lxqt && \
    echo '[Desktop]\n\
ShowHidden=true\n\
Wallpaper=/usr/share/lxqt/themes/ambiance/Butterfly-Kenneth-Wimer.jpg\n\
WallpaperMode=stretch\n\
' >/etc/skel/.config/pcmanfm-qt/lxqt/settings.conf

# config panel / add some launchers
RUN mkdir -p /etc/xdg/lxqt && echo '[quicklaunch]\n\
alignment=Left\n\
apps\\1\desktop=/usr/share/applications/pcmanfm-qt.desktop\n\
apps\\2\desktop=/usr/share/applications/qterminal.desktop\n\
apps\\3\desktop=/usr/share/applications/juffed.desktop\n\
apps\size=3\n\
type=quicklaunch\n\
' >> /etc/xdg/lxqt/panel.conf


RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz
RUN tar -xvf v1.2.0.tar.gz
RUN mkdir  $HOME/.vnc
RUN echo 'admin123@aA' | vncpasswd -f > $HOME/.vnc/passwd
RUN echo '/bin/env  MOZ_FAKE_NO_SANDBOX=1  dbus-launch --exit-with-session startlxqt'  > $HOME/.vnc/xstartup
RUN chmod 600 $HOME/.vnc/passwd
RUN chmod 755 $HOME/.vnc/xstartup
RUN echo 'whoami ' >>/luo.sh
RUN echo 'cd ' >>/luo.sh
RUN echo "su -l -c 'vncserver :2000 -geometry 1360x768' "  >>/luo.sh
RUN echo 'cd /noVNC-1.2.0' >>/luo.sh
RUN echo './utils/launch.sh  --vnc localhost:7900 --listen 8900 ' >>/luo.sh
RUN chmod 755 /luo.sh
EXPOSE 8900
CMD  /luo.sh
