#ifndef QUATERNION_H
#define QUATERNION_H

#include <math.h>

typedef struct {
    double w, x, y, z;
} Quaternion;

typedef struct {
    double w, x, y, z;
} Q_angle;

// Function declarations
double quaternion_norm(Quaternion q);
Quaternion quaternion_conjugate(Quaternion q);
Quaternion quaternion_multiply(Quaternion q1, Quaternion q2);
Quaternion quaternion_inverse(Quaternion q);
Quaternion relative_quaternion(Quaternion q1, Quaternion q2);
Q_angle quaternion_angle(Quaternion q);

#endif // QUATERNION_H

