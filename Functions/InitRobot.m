function [h_M, h_L, h_R, H_M, H_L, H_R, AA_M] = InitRobot(DH_L, DH_R, P_E, F_E, P_G, F_G)
% Função usada para gerar todos os elos, eixos e garras dor robô
%
% -Input 
% DH_L - Matriz DH do braço esquerdo
% DH_R - Matriz DH do braço direito
% P_E - Pontos dos eixos
% F_E - Faces dos eixos
% P_G - Pontos da garra
% F_G - Faces da garra
%
% -Output
% h_M - linhas do tronco do robô
% h_L - linhas do braço esquerdo
% h_R - linhas do braço direito
% H_M - Array de handles graficos do tronco do robô
% H_L - Array de handles graficos do braço esquerdo
% H_R - Array de handles graficos do braço direito
% AA_M - Set de G.T. do troco do robô

% Ângulos Zero Hardware 
MQ = [0 0 0 0 0 0 0 0 0]';

MDH_L = GenerateMultiDH(DH_L,MQ);
MDH_R = GenerateMultiDH(DH_R,MQ);

AA_M = Tlinks(MDH_L(1:2,:,1));
AA_L = Tlinks(MDH_L(2:9,:,1)); 
AA_R = Tlinks(MDH_R(2:9,:,1)); 

Org_M = LinkOrigins(AA_M);
Org_L = LinkOrigins(AA_L,AA_M); 
Org_R = LinkOrigins(AA_R,AA_M);

% Desenhar os links do robô
h_M = DrawLinks(Org_M); 
h_L = DrawLinks(Org_L); 
h_R = DrawLinks(Org_R); 
% Desenhar os eixos e as garras
H_M = DrawFrames(AA_M,P_E,F_E, P_G, F_G);
H_L = DrawFrames(AA_L, P_E, F_E, P_G, F_G, AA_M); 
H_R = DrawFrames(AA_R, P_E, F_E, P_G, F_G, AA_M); 

end