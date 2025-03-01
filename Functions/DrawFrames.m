function H = DrawFrames(AA,P_E,F_E,P_G,F_G,AA_O)
% AA - G.T. of Robot
% P object points
% F object face
% H - vector of graphic handle

T = eye(4);

if nargin == 6
     T = T*AA_O(:,:,1);
else
    patch("Vertice",P_E(1:3,:)',"Faces",F_E,"Facecolor","w");
end

for i = 1:size(AA,3)
    T = T*AA(:,:,i);

    if i == size(AA,3) && i > 2
        Q = T*P_G;
        H{i} = patch("Vertice",Q(1:3,:)',"Faces",F_G);
    else
        Q = T*P_E;
        H{i} = patch("Vertice",Q(1:3,:)',"Faces",F_E,"Facecolor", rand(1,3));
    end
end
end