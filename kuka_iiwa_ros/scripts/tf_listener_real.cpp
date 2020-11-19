#include <ros/ros.h>
#include <tf/transform_listener.h>
#include <tf/transform_broadcaster.h>

#include <geometry_msgs/PoseStamped.h>

geometry_msgs::PoseStamped message_convert(tf::StampedTransform transform, std::string ref_frame)
{
  geometry_msgs::PoseStamped msg_convert;
  msg_convert.header.frame_id = ref_frame;
  msg_convert.pose.position.x = transform.getOrigin().x();
  msg_convert.pose.position.y = transform.getOrigin().y();
  msg_convert.pose.position.z = transform.getOrigin().z();
  msg_convert.pose.orientation.x = transform.getRotation().x();
  msg_convert.pose.orientation.y = transform.getRotation().y();
  msg_convert.pose.orientation.z = transform.getRotation().z();
  msg_convert.pose.orientation.w = transform.getRotation().w();
  
  return msg_convert;
}

int main(int argc, char** argv){
  ros::init(argc, argv, "my_tf_listener_real");

  ros::NodeHandle node;

  ros::Publisher pub_ee_left = node.advertise<geometry_msgs::PoseStamped>("/pose_robot_left", 10);
  ros::Publisher pub_ee_right = node.advertise<geometry_msgs::PoseStamped>("/pose_robot_right", 10);

  tf::TransformListener listener;
  geometry_msgs::PoseStamped msg_convert_left;
  geometry_msgs::PoseStamped msg_convert_right;
  tf::TransformBroadcaster br;
  tf::TransformBroadcaster br2;
  tf::Transform transform;
  transform.setOrigin( tf::Vector3(0.5, -0.35, 0.4) );
  tf::Quaternion q;
  q.setRPY(0, 0, 0);
  transform.setRotation(q);
  tf::Transform transform2;
  transform2.setOrigin( tf::Vector3(0.5,1.35,0.4) );
  transform2.setRotation(q);  
  ros::Rate rate(300);
  while (node.ok()){

    tf::StampedTransform transform_ee_left;
    tf::StampedTransform transform_ee_right;


    br.sendTransform(tf::StampedTransform(transform, ros::Time::now(), "world", "iiwa1/iiwa1_base"));
    br2.sendTransform(tf::StampedTransform(transform2, ros::Time::now(), "world", "iiwa2/iiwa2_base"));

    try {
          // listener.waitForTransform("world", "iiwa1_link_ee", ros::Time(0), ros::Duration(10.0) );
          // listener.lookupTransform("world", "iiwa1_link_ee", ros::Time(0), transform_ee_left);
          listener.waitForTransform("iiwa1/iiwa1_base", "iiwa1/iiwa_link_ee", ros::Time(0), ros::Duration(.01) );
          listener.lookupTransform("iiwa1/iiwa1_base", "iiwa1/iiwa_link_ee", ros::Time(0), transform_ee_left);

        } 
    catch (tf::TransformException ex) {
      ROS_ERROR("%s",ex.what());
      }

    try {
          // listener.waitForTransform("world", "iiwa2_link_ee", ros::Time(0), ros::Duration(10.0) );
          // listener.lookupTransform("world", "iiwa2_link_ee", ros::Time(0), transform_ee_right);
          listener.waitForTransform("world", "iiwa2/iiwa_link_ee", ros::Time(0), ros::Duration(.01) );
          listener.lookupTransform("world", "iiwa2/iiwa_link_ee", ros::Time(0), transform_ee_right);
        } 
    catch (tf::TransformException ex) {
      ROS_ERROR("%s",ex.what());
      }

    msg_convert_left = message_convert(transform_ee_left, "world");
    pub_ee_left.publish(msg_convert_left);
    msg_convert_right = message_convert(transform_ee_right, "world");
    pub_ee_right.publish(msg_convert_right);
    rate.sleep();
  }
  return 0;
};
