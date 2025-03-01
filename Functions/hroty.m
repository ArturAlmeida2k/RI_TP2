function [T] = hroty(a)
%T - homogeneous rotation matrix around y
%a - angle in radianz

T = [cos(a)  0 sin(a) 0
     0       1 0      0
     -sin(a) 0 cos(a) 0
     0       0 0      1];

end