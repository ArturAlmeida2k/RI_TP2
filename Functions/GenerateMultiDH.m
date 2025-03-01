function MDH = GenerateMultiDH(DH,MQ,t)

% DH - DH matrix (base in zero HW config)
% MQ - Matrix of sucessive joint positions
% t - vector with types of joints (0-rot, 1-lin)
% MDH - Hypermatrix of DH for all positions in MQ

if nargin < 3
    t = zeros(1,size(DH,1)); % all joints are rot (deafault)
end

MDH = zeros(size(DH,1),size(DH,2),size(MQ,2));

for n = 1:size(MQ,2)
    MDH(:,:,n) = DH;
    for i = 1:size(DH,1) % test all joints
        if t(i) == 0
            MDH(i,1,n) = MDH(i,1,n) + MQ(i,n); % update qi variables from MQ matrix
        else
            MDH(i,3,n) = MDH(i,3,n) + MQ(i,n); % update qi variables from MQ matrix
        end
    end
end

end