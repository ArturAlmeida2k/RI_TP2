function AA = Tlinks(DH)
%   DH - matrix of kinem, parameters
%        th_1, l_1, d_1, alpha_1
%   AA - set of A G.T.

AA = zeros(4,4,size(DH,1));

for i=1:size(DH,1)
    AA(:,:,i) = Tlink(DH(i,1),DH(i,2),DH(i,3),DH(i,4));
end