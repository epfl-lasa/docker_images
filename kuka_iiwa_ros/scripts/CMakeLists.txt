cmake_minimum_required(VERSION 3.5)
project(kuka_iiwa_simulator)

## Find catkin and any catkin packages
#find_package(catkin REQUIRED COMPONENTS roscpp geometry_msgs gazebo_msgs)

## Declare a catkin package
#catkin_package()

# Load catkin and all dependencies required for this package
find_package(catkin REQUIRED COMPONENTS 
  roscpp 
  tf
)

# Depend on system install of Gazebo
#set(CMAKE_CXX_FLAGS "-std=c++0x ${CMAKE_CXX_FLAGS}")
find_package(gazebo REQUIRED)

link_directories(${GAZEBO_LIBRARY_DIRS})
include_directories(${Boost_INCLUDE_DIR} ${catkin_INCLUDE_DIRS} ${GAZEBO_INCLUDE_DIRS})

catkin_package(
  DEPENDS 
    roscpp 
    tf
)

add_executable(tf_listener_sm tf_listener_sm.cpp)
target_link_libraries(tf_listener_sm ${catkin_LIBRARIES})

add_executable(tf_listener_real tf_listener_real.cpp)
target_link_libraries(tf_listener_real ${catkin_LIBRARIES})

add_executable(obj_marker object_marker.cpp)
target_link_libraries(obj_marker ${catkin_LIBRARIES})

add_executable(cmd_converter command_converter.cpp)
target_link_libraries(cmd_converter ${catkin_LIBRARIES})

add_executable(cmd_converter_real command_converter_real.cpp)
target_link_libraries(cmd_converter_real ${catkin_LIBRARIES})
