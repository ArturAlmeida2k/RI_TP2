function [T] = hrotx(a)
%T - homogeneous rotation matrix around x
%a - angle in radianz

T = [1 0      0       0
     0 cos(a) -sin(a) 0
     0 sin(a) cos(a)  0
     0 0      0       1];

end