#include "relativeq.h"

// Function to calculate the norm of a quaternion
double quaternion_norm(Quaternion q) {
    return sqrt(q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z);
}

// Function to calculate the conjugate of a quaternion
Quaternion quaternion_conjugate(Quaternion q) {
    Quaternion q_conj = {q.w, -q.x, -q.y, -q.z};
    return q_conj;
}

// Function to multiply two quaternions
Quaternion quaternion_multiply(Quaternion q1, Quaternion q2) {
    Quaternion q;
    q.w = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z;
    q.x = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y;
    q.y = q1.w * q2.y - q1.x * q2.z + q1.y * q2.w + q1.z * q2.x;
    q.z = q1.w * q2.z + q1.x * q2.y - q1.y * q2.x + q1.z * q2.w;
    return q;
}

// Function to calculate the inverse of a quaternion
Quaternion quaternion_inverse(Quaternion q) {
    double norm_sq = q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z;
    Quaternion q_conj = quaternion_conjugate(q);
    Quaternion q_inv = {q_conj.w / norm_sq, q_conj.x / norm_sq, q_conj.y / norm_sq, q_conj.z / norm_sq};
    return q_inv;
}

// Function to calculate the relative quaternion
Quaternion relative_quaternion(Quaternion q1, Quaternion q2) {
    Quaternion q1_inv = quaternion_inverse(q1);
    Quaternion q_rel = quaternion_multiply(q1_inv, q2);
    return q_rel;
}

// Function to get the angle from a quaternion
Q_angle quaternion_angle(Quaternion q) 
{
  Q_angle angle; 
  angle.w = 2.0 * acos(q.w); // Convert to degrees
  angle.x = acos(q.x / sin(angle.w/2)) * 57.29;
  angle.y = acos(q.y / sin(angle.w/2)) * 57.29;
  angle.z = acos(q.z / sin(angle.w/2)) * 57.29;
  return angle;

}


