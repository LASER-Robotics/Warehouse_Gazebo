# get the path to this script

PNAME=$( ps -p "$$" -o comm= )
SNAME=$( echo "$SHELL" | grep -Eo '[^/]+/?$' )

if [ "$SNAME" = "bash" ]; then
  MY_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
else
  MY_PATH=`dirname "$0"`
  MY_PATH=`( cd "$MY_PATH" && pwd )`
fi

distro=`lsb_release -r | awk '{ print $2 }'`
[ "$distro" = "18.04" ] && ROS_DISTRO="melodic"
[ "$distro" = "20.04" ] && ROS_DISTRO="noetic"


## --------------------------------------------------------------
## |                       waitFor* macros                      |
## --------------------------------------------------------------

# #{ waitForRos()

waitForRos() {
  until rostopic list > /dev/null 2>&1; do
    echo "waiting for ros"
    sleep 1;
  done
}

# #}

# #{ waitForSimulation()

waitForSimulation() {
  until timeout 6s rostopic echo /gazebo/model_states -n 1 --noarr > /dev/null 2>&1; do
    echo "waiting for simulation"
    sleep 1;
  done
  sleep 1;
}

# #}

# #{waitForControl2()
waitForControl2(){
    until timeout 6s rostopic echo /my_robot/joint1_position_controller/state -n 1 --noarr > /dev/null 2>&1; do
        echo "waiting for control2"
        sleep 1;
    done
    sleep 1;
}

# #}

# #{ waitForSimulation()

waitForSpawn() {
  until timeout 6s rostopic echo /mrs_drone_spawner/spawned -n 1 --noarr > /dev/null 2>&1; do
    echo "waiting for spawn"
    sleep 1;
  done
  sleep 1;
}

# #}

# #{ waitForOdometry()

waitForOdometry() {
  until timeout 6s rostopic echo /$UAV_NAME/mavros/local_position/odom -n 1 --noarr > /dev/null 2>&1; do
    echo "waiting for odometry"
    sleep 1;
  done
}

# #}

# #{ waitForControlManager()

waitForControlManager() {
  until timeout 6s rostopic echo /$UAV_NAME/control_manager/diagnostics -n 1 --noarr > /dev/null 2>&1; do
    echo "waiting for control manager"
    sleep 1;
  done
}

# #}

# #{ waitForControl()

waitForControl() {
  until timeout 6s rostopic echo /$UAV_NAME/control_manager/diagnostics -n 1 --noarr > /dev/null 2>&1; do
    echo "waiting for control"
    sleep 1;
  done
  until timeout 6s rostopic echo /$UAV_NAME/odometry/odom_main -n 1 --noarr > /dev/null 2>&1; do
    echo "waiting for odom_main"
    sleep 1;
  done
}

# #}

# #{ waitForMpc()

waitForMpc() {
  until timeout 6s rostopic echo /$UAV_NAME/control_manager/diagnostics -n 1 --noarr > /dev/null 2>&1; do
    echo "waiting for control"
    sleep 1;
  done
  until timeout 6s rostopic echo /$UAV_NAME/odometry/odom_main -n 1 --noarr > /dev/null 2>&1; do
    echo "waiting for odom_main"
    sleep 1;
  done
}

# #}

# #{ waitForOffboard()

waitForOffboard() {
  until timeout 6s rostopic echo /$UAV_NAME/control_manager/offboard_on -n 1 --noarr > /dev/null 2>&1; do
    echo "waiting for offboard mode"
    sleep 1;
  done
}

# #}

# #{ waitForCompile()

waitForCompile() {
  while timeout 6s  ps aux | grep "catkin build" | grep -v grep > /dev/null 2>&1; do
    echo "waiting for compilation to complete"
    sleep 1;
  done
}

# #}

# #{ appendBag()

appendBag() {

  if [ "$#" -ne 1 ]; then
    echo ERROR: please supply one argument: the text that should be appended to the name of the folder with the latest rosbag file and logs
  else

    bag_adress=`readlink ~/bag_files/latest`

    if test -d "$bag_adress"; then

      appended_adress=$bag_adress$1
      mv $bag_adress $appended_adress
      ln -sf $appended_adress ~/bag_files/latest
			second_symlink_adress=$(sed 's|\(.*\)/.*|\1|' <<< $appended_adress)
      ln -sf $appended_adress $second_symlink_adress/latest

      echo Rosbag name appended: $appended_adress

    else
      echo ERROR: symlink ~/bag_files/latest does not point to a file! - $bag_adress
    fi
  fi
}

# #}