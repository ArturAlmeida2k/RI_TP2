function [Q_L_f, Q_R_f, AAA_L, AAA_R] = J0Mov(DH_L, DH_R, Q_L_i, Q_R_i, J0, NN)
% Esta função é responsavel por girar o robô só mundando a junta do tronco
%
% -Inputs:
% DH_L, DH_R - DH de ambos os braços
% Q_L_i, Q_R_i - Ângulos do robô inicial
% J0 - Tem o valor de 0 ou pi e define para que lado o robo estará virado 
% NN - Número de iterações
% 
% -Output:
% Q_L_f, Q_R_f - Ângulos do robô final
% AAA_L, AAA_R - Matriz 4-D com os movimentos de cada robô


Q_L_f = Q_L_i;
Q_L_f(2) = J0;

Q_R_f = Q_R_i;
Q_R_f(2) = J0;

MQ_e = LinspaceVect(Q_L_i,Q_L_f,NN);
MQ_d = LinspaceVect(Q_R_i,Q_R_f,NN);

MDH_L = GenerateMultiDH(DH_L,MQ_e);
MDH_R = GenerateMultiDH(DH_R,MQ_d);
AAA_L = CalculateRobotMotion(MDH_L);
AAA_R = CalculateRobotMotion(MDH_R);

end