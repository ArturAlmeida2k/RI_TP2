function Z = JointAxes(AA)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Z = [0 0 1]';
A= eye(4);
for n = 1:size(AA,3)
    A= A*AA(:,:,n); % cumulative multiplication
    Z(:,n+1) = A(1:3,3); % vector of 
end