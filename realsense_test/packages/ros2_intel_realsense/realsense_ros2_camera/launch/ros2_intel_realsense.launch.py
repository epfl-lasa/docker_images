# Copyright (c) 2018 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Launch realsense_ros2_camera node and rviz."""

import os

from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
import launch_ros.actions
import launch.actions

def generate_launch_description():
    enable_align_depth = launch.substitutions.LaunchConfiguration('enable_aligned_depth',
                                                                  default='true')
    enable_depth = launch.substitutions.LaunchConfiguration('enable_depth',
                                                                  default='true')
    default_rviz = os.path.join(get_package_share_directory('realsense_ros2_camera'),
                                'launch', 'default.rviz')
    return LaunchDescription([
        # Realsense
        launch_ros.actions.Node(
            package='realsense_ros2_camera', 
            node_executable='realsense_ros2_camera',
            parameters=[{'enable_aligned_depth': enable_align_depth},{'enable_depth': enable_depth}],
            output='screen'),

        # Rviz
        launch_ros.actions.Node(
            package='rviz2', node_executable='rviz2', output='screen',
            arguments=['--display-config', default_rviz]),
    ])
