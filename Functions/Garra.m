function [P,F] = Garra(scale)
% Função utilizada para obter os pontos e faces de uma garra de robo virada
% no sentido do eixo Z
%
% -Inputs:
% scale - Escala desejada para a garra
%
% -Output:
% P - pontos que definem a garra
% F - faces que definem a garra

c = scale * 40;
l = scale * 4;
h = scale * 20;
s = scale * c;

side =  [0  0  0
         l  0  0
         0  h  0
         l  h  0
         0  0  c
         l  0  c
         0  h  c
         l  h  c];

connector = [0  0  0
             s  0  0
             0  h/2  0
             s  h/2  0
             0  0  l
             s  0  l
             0  h/2  l
             s  h/2  l];


LS = htrans(-s/2-l,-h/2,0) * [side';ones(1,size(side,1))];
RS = htrans(s/2,-h/2,0) * [side';ones(1,size(side,1))];
MS = htrans(-s/2,-h/4,0) * [connector';ones(1,size(connector,1))] ;

FS = [1 2 4 3
      1 3 7 5
      1 2 6 5
      5 6 8 7
      2 4 8 6
      3 4 8 7];

P = [LS RS MS];

P = htrans(0, 0, -l) * P;

F = [FS
     FS+8
     FS+16];
end