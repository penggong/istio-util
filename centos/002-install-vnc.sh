yum upgrade
yum -y groupinstall "X Window System"
#时间有点长 704多个包
yum -y groups install "GNOME Desktop"
nohup startx & > gnome.log

echo "GNOME Desktop started"

yum install -y xorg-x11-xauth xterm libXi libXp libXtst libXtst-devel libXext libXext-devel
yum install -y Xvfb
yum install -y x11vnc

nohup x11vnc -rfbport 12345 -passwd ls123456 -create -forever & > vnc.log

echo "vnc server started"
