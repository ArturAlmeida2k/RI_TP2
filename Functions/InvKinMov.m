function [Q_L_f, Q_R_f, AAA_L, AAA_R] = InvKinMov(Robot_Dim, DH_L, DH_R, P_L, P_R, Q_L_i, Q_R_i, NN, J0, angle_B1, angle_B2, Step)
% Esta função é responsavel por o calculo da cinematica inversa e guardar o
% movimento
%
% -Inputs:
% Robot_Dim - Dimensões do robô
% DH_L, DH_R - DH de ambos os braços
% P_L, P_R - Ponto de aproximação do bloco esquerdo e direito
% Q_L_i, Q_R_i - Ângulos do robô inicial
% NN - Número de iterações
% J0 - Tem o valor de 0 ou pi e define para que lado o robo estará virado  
% angle_B1, angle_B2 - Ângulo dos blocos
% Step - String com o passo a ser realizado de momento
% 
% -Output:
% Q_L_f, Q_R_f - Ângulos do robô final
% AAA_L, AAA_R - Matriz 4-D com os movimentos de cada robô

% Ângulos do braço esquerdo
Q_L = InvKinBraco(P_L(1), P_L(2), P_L(3), Robot_Dim, J0, 0, Step);
Q_L = [Q_L
       InvKinPulso(P_L(1), P_L(2), P_L(3), DH_L, Q_L, angle_B1, 0, Step)];

% Ângulos do braço direito
Q_R = InvKinBraco(P_R(1), P_R(2), P_R(3), Robot_Dim, J0, 1, Step);
Q_R = [Q_R 
       InvKinPulso(P_R(1), P_R(2), P_R(3), DH_R, Q_R, angle_B2, 1, Step)];

Q_L_f = [0 J0 Q_L']';
Q_R_f = [0 J0 Q_R']';

MQ_e = LinspaceVect(Q_L_i, Q_L_f, NN);
MQ_d = LinspaceVect(Q_R_i, Q_R_f, NN);

MDH_L = GenerateMultiDH(DH_L, MQ_e);
MDH_R = GenerateMultiDH(DH_R, MQ_d);
AAA_L = CalculateRobotMotion(MDH_L);
AAA_R = CalculateRobotMotion(MDH_R);
end