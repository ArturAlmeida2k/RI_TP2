function [T] = hrotz(a)
%T - homogeneous rotation matrix around z
%a - angle in radianz

T = [cos(a) -sin(a) 0 0
     sin(a)  cos(a) 0 0
     0       0      1 0
     0       0      0 1];

end