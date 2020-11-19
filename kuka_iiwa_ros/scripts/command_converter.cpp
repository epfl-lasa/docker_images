#include <ros/ros.h>
#include <std_msgs/Float64MultiArray.h>
#include <geometry_msgs/TwistStamped.h>
#include <iostream>

class SubscribeAndPublish
{

private:
  std::vector<double>cmd_left;
  std::vector<double>cmd_right;
  std_msgs::Float64MultiArray cmd_convert_left;
  std_msgs::Float64MultiArray cmd_convert_right;
  ros::NodeHandle n_; 
  ros::Publisher pub_left;
  ros::Subscriber sub_left_position;
  ros::Subscriber sub_left_orientation;
  ros::Publisher pub_right;
  ros::Subscriber sub_right_position;
  ros::Subscriber sub_right_orientation;

public:

  SubscribeAndPublish()
  {
    this->pub_left = n_.advertise<std_msgs::Float64MultiArray>("/iiwa1/CustomControllers/command", 10);
    this->sub_left_position = n_.subscribe("/position_left", 1, &SubscribeAndPublish::callback_position_left, this);
    this->sub_left_orientation = n_.subscribe("/orientation_left", 1, &SubscribeAndPublish::callback_orientation_left, this);

    this->pub_right = n_.advertise<std_msgs::Float64MultiArray>("/iiwa2/CustomControllers/command", 10);
    this->sub_right_position = n_.subscribe("/position_right", 1, &SubscribeAndPublish::callback_position_right, this);
    this->sub_right_orientation = n_.subscribe("/orientation_right", 1, &SubscribeAndPublish::callback_orientation_right, this);

    // this->cmd_left = {0,0,0,0,0,0,0,0,0};
    // this->cmd_right = {0,0,0,0,0,0,0,0,0};
    this->cmd_left = {0,0,0,0,0,0,0,0,0,0,0,0};
    this->cmd_right = {0,0,0,0,0,0,0,0,0,0,0,0};
  }

  void callback_orientation_left(const geometry_msgs::TwistStamped::ConstPtr& msg)
  {
    this->cmd_left[0] = msg->twist.angular.x;
    this->cmd_left[1] = msg->twist.angular.y;
    this->cmd_left[2] = msg->twist.angular.z;
    this->cmd_left[3] = msg->twist.linear.x;
    this->cmd_left[4] = msg->twist.linear.y;
    this->cmd_left[5] = msg->twist.linear.z;
    // this->cmd_left[6] = msg->twist.linear.x;
    // this->cmd_left[7] = msg->twist.linear.y;
    // this->cmd_left[8] = msg->twist.linear.z;

    this->publish_left();
  }

  void callback_position_left(const geometry_msgs::TwistStamped::ConstPtr& msg)
  {

    // this->cmd_left[6] = msg->twist.linear.x;
    // this->cmd_left[7] = msg->twist.linear.y;
    // this->cmd_left[8] = msg->twist.linear.z;

    this->cmd_left[9] = msg->twist.linear.x;
    this->cmd_left[10] = msg->twist.linear.y;
    this->cmd_left[11] = msg->twist.linear.z;
    this->cmd_left[6] = msg->twist.angular.x;
    this->cmd_left[7] = msg->twist.angular.y;
    this->cmd_left[8] = msg->twist.angular.z;

    this->publish_left();

  }

  void callback_orientation_right(const geometry_msgs::TwistStamped::ConstPtr& msg)
  {
    this->cmd_right[0] = msg->twist.angular.x;
    this->cmd_right[1] = msg->twist.angular.y;
    this->cmd_right[2] = msg->twist.angular.z;
    this->cmd_right[3] = msg->twist.linear.x;
    this->cmd_right[4] = msg->twist.linear.y;
    this->cmd_right[5] = msg->twist.linear.z;
    // this->cmd_right[6] = msg->twist.linear.x;
    // this->cmd_right[7] = msg->twist.linear.y;
    // this->cmd_right[8] = msg->twist.linear.z;

    this->publish_right();

  }

  void callback_position_right(const geometry_msgs::TwistStamped::ConstPtr& msg)
  {
    // this->cmd_right[6] = msg->twist.linear.x;
    // this->cmd_right[7] = msg->twist.linear.y;
    // this->cmd_right[8] = msg->twist.linear.z;


    this->cmd_right[9] = msg->twist.linear.x;
    this->cmd_right[10] = msg->twist.linear.y;
    this->cmd_right[11] = msg->twist.linear.z;
    this->cmd_right[6] = msg->twist.angular.x;
    this->cmd_right[7] = msg->twist.angular.y;
    this->cmd_right[8] = msg->twist.angular.z;

    this->publish_right();

  }

  void publish_left()
  {
    this->cmd_convert_left.data = this->cmd_left; 
    this->pub_left.publish(this->cmd_convert_left);
  }

  void publish_right()
  {
    this->cmd_convert_right.data = this->cmd_right; 
    this->pub_right.publish(this->cmd_convert_right);
  }

};

int main(int argc, char **argv)
{
  //Initiate ROS
  ros::init(argc, argv, "converter");

  SubscribeAndPublish SAPObject;

  ros::Rate loop_rate(200);

  while (ros::ok())
  {
    ros::spin();
    loop_rate.sleep();
  }

  return 0;
}
