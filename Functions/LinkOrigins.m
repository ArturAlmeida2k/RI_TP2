function [Org] = LinkOrigins(AA,AA_O)

%  AA - hypermatrix of robot G.T.
% Org - matrix (3 x (size(AA,3) + 1)) with links' origins

if nargin == 2
    Org = zeros(3,size(AA,3));
    T = eye(4);
    T = T*AA_O(:,:,1);
    for i = 1:size(AA,3)
        T = T*AA(:,:,i);
        Org(:,i) = T(1:3,4);    
    end
else
    Org = zeros(3,size(AA,3)+1);
    T = eye(4);  
    for i = 1:size(AA,3)
        T = T*AA(:,:,i);
        Org(:,i+1) = T(1:3,4);
    end
end


end