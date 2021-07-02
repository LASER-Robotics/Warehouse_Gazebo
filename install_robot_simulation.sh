#!/bin/bash

sudo apt-get install ros-noetic-ros-control ros-noetic-ros-controllers

sudo apt-get install ros-noetic-gazebo-ros-pkgs ros-noetic-gazebo-ros-control

sudo apt-get install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.8

sudo apt-get install ros-fuerte-visualization

sudo apt-get install -y joint-state-publisher

git clone https://github.com/LASER-Robotics/Warehouse_Gazebo.git