function [h_B1, h_B2, P_B, y_B1, y_B2, angle_B1, angle_B2] = InitBlocks(WBL, LBL, HBL, STF, WTS, DS, SL)
% Esta função é que calcula aleatoriamente a posição e angulos dos blocos e
% desenha os mesmos.
%
% -Inputs:
% WBL, LBL, HBL - Dimensões dos blocos
% STF, WTS, DS, SL - Dimensões da mesa
%
% -Outputs:
% h_B1, h_B2 - Patches dos blocos
% P_B - Pontos dos blocos
% y_B1, y_B2 - A posição em y aleatoriamente escolhida
% angle_B1, angle_B2 - Ângulos aleatriamente escolhidos para os 2 blocos

[P_B, F_B] = Bloco(WBL, LBL, HBL);

h_B1 = patch("Vertices", P_B(1:3,:)' , "Faces", F_B ,"FaceColor", 'r');
h_B2 = patch("Vertices", P_B(1:3,:)' , "Faces", F_B ,"FaceColor", 'b');

angle_B1 = pi * rand;
offset =  max(LBL*abs(cos(angle_B1))/2, WBL*abs(sin(angle_B1))/2);
ymin_B1 = STF/2+SL+DS+offset;
ymax_B1 = STF/2+SL+DS+WTS-offset;
y_B1 = ymin_B1 + (ymax_B1 - ymin_B1) * rand;

angle_B2 = pi + pi * rand;
offset = max(LBL*abs(cos(angle_B2))/2, WBL*abs(sin(angle_B2))/2);
ymin_B2 = STF/2+SL+DS+offset;
ymax_B2 = STF/2+SL+DS+WTS-offset;
y_B2 = ymin_B2 + (ymax_B2 - ymin_B2) * rand;
end