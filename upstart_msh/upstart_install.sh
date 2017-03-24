#!/bin/bash

robot_name="${HOSTNAME//-b1}"

sudo apt-get install ros-indigo-robot-upstart
sudo apt-get install tmux

sudo cp /u/robot/git/setup_cob4/upstart_msh/cob.conf /etc/init/cob.conf
sudo cp /u/robot/git/setup_cob4/upstart_msh/cob-start /usr/sbin/cob-start
sudo sed -i "s/myrobotname/$robot_name/g" /usr/sbin/cob-start
sudo sed -i "s/mydistro/$ROS_DISTRO/g" /usr/sbin/cob-start
sudo sed -i "s/myrobot/$ROBOT/g" /usr/sbin/cob-start
sudo sed -i "s/myuser/msh/g" /usr/sbin/cob-start
echo "%users ALL=NOPASSWD:/usr/sbin/cob-start" | sudo tee -a /etc/sudoers

sudo cp /u/robot/git/setup_cob4/scripts/cob-stop /usr/sbin/cob-stop
sudo sed -i "s/myrobotname/$robot_name/g" /usr/sbin/cob-stop
sudo sed -i "s/myuser/msh/g" /usr/sbin/cob-stop
echo "%users ALL=NOPASSWD:/usr/sbin/cob-stop" | sudo tee -a /etc/sudoers

sudo cp /u/robot/git/setup_cob4/upstart_msh/cob-start-vm-win /usr/sbin/cob-start-vm-win
sudo sed -i "s/myrobotname/$robot_name/g" /usr/sbin/cob-start-vm-win
echo "%users ALL=NOPASSWD:/usr/sbin/cob-start-vm-win" | sudo tee -a /etc/sudoers

sudo cp /u/robot/git/setup_cob4/upstart_msh/cob-stop-vm-win /usr/sbin/cob-stop-vm-win
sudo sed -i "s/myrobotname/$robot_name/g" /usr/sbin/cob-stop-vm-win
echo "%users ALL=NOPASSWD:/usr/sbin/cob-stop-vm-win" | sudo tee -a /etc/sudoers

sudo cp /u/robot/git/setup_cob4/scripts/cob-command /usr/sbin/cob-command
sudo echo "%users ALL=NOPASSWD:/usr/sbin/cob-command" | sudo tee -a /etc/sudoers

camera_client_list="
$robot_name-t2
$robot_name-t3
$robot_name-s1"

for client in $camera_client_list; do
        echo "-------------------------------------------"
        echo "Executing on $client"
        echo "-------------------------------------------"
        echo ""
        ssh $client "sudo cp /u/robot/git/setup_cob4/upstart_msh/check_cameras.sh /etc/init.d/check_cameras.sh"
        ssh $client "sudo update-rc.d check_cameras.sh defaults"
done
