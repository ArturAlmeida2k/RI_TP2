function MovPrev(AAA_L,AAA_R)

for n = 1:size(AAA_L,4)
    if mod(n,5) == 0
        T_L = eye(4);
        T_R = eye(4);
        for j = 1:size(AAA_L,3)
            T_L = T_L*AAA_L(:,:,j,n);
            T_R = T_R*AAA_R(:,:,j,n);
        end
        plot3(T_L(1,4), T_L(2,4), T_L(3,4), "x", 'Color', [1, 0.5, 0], "Tag", "prev")
        plot3(T_R(1,4), T_R(2,4), T_R(3,4), "x", 'Color', [1, 1, 0], "Tag", "prev")
    end
    pause(0.005)
end
