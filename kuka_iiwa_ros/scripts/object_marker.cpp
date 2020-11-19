#include "ros/ros.h"
#include "visualization_msgs/Marker.h"

#include <ros/ros.h>
#include <std_msgs/Float64MultiArray.h>
#include <geometry_msgs/PoseStamped.h>

class SubscribeAndPublish
{
public:
  SubscribeAndPublish()
  {
    pub = n_.advertise<visualization_msgs::Marker>( "visualization_marker", 0 );
    sub = n_.subscribe("/desired_pose_object", 1, &SubscribeAndPublish::callback, this);
  }

  visualization_msgs::Marker visualize_pose(const geometry_msgs::PoseStamped::ConstPtr& msg)
  {

    visualization_msgs::Marker marker;
    marker.header.frame_id = "world";
    marker.header.stamp = ros::Time();
    marker.ns = "my_namespace";
    marker.id = 0;
    marker.type = visualization_msgs::Marker::CUBE;
    marker.action = visualization_msgs::Marker::ADD;
    marker.pose.position.x = msg->pose.position.x;
    marker.pose.position.y = msg->pose.position.y;
    marker.pose.position.z = msg->pose.position.z;
    marker.pose.orientation.x = msg->pose.orientation.x;
    marker.pose.orientation.y = msg->pose.orientation.y;
    marker.pose.orientation.z = msg->pose.orientation.z;
    marker.pose.orientation.w = msg->pose.orientation.w;
    marker.scale.x = 0.3;
    marker.scale.y = 0.3;
    marker.scale.z = 0.3;
    marker.color.a = 1.0;
    marker.color.r = 0.0;
    marker.color.g = 0.5;
    marker.color.b = 0.5;
    //only if using a MESH_RESOURCE marker type:
    //marker.mesh_resource = "package://pr2_description/meshes/base_v0/base.dae";

    return marker;
  }

  void callback(const geometry_msgs::PoseStamped::ConstPtr& msg)
  {
    pub.publish(visualize_pose(msg));
  }

private:
  ros::NodeHandle n_; 
  ros::Publisher pub;
  ros::Subscriber sub;

};

int main(int argc, char **argv)
{
  //Initiate ROS
  ros::init(argc, argv, "visualize");

  SubscribeAndPublish SAPObject;

  ros::Rate loop_rate(1000);

  while (ros::ok())
  {
    ros::spin();
    loop_rate.sleep();
  }

  return 0;
}
