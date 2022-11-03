#!/bin/bash

sudo apt-get install ros-noetic-ros-control ros-noetic-ros-controllers

sudo apt-get install ros-noetic-gazebo-ros-pkgs ros-noetic-gazebo-ros-control

sudo apt-get install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.8
sudo apt-get install tmux

sudo apt-get install ros-fuerte-visualization

sudo apt-get install -y joint-state-publisher

echo "Creating a Workspace"
mkdir -p ~/catkin_warehouse/src
cd ~/catkin_warehouse
catkin_make

cd src

git clone https://github.com/LASER-Robotics/Warehouse_Gazebo.git

cd Warehouse_Gazebo/robot_control/scripts/
chmod +x laser_teleop_keyboard
cd ~/catkin_warehouse/src/Warehouse_Gazebo/robot_description/session/
chmod +x open_robot.sh

echo 'source ~/catkin_warehouse/devel/setup.bash' >>~/.bashrc

echo 'source ~/catkin_warehouse/src/Warehouse_Gazebo/robot_description/session/shell_additions.sh' >>~/.bashrc

cd ~/catkin_warehouse

catkin_make
