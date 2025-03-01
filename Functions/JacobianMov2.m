function [Q_L_f, Q_R_f, AAA_L, AAA_R] = JacobianMov2(DH_L, DH_R, Q_L_i, Q_R_i, dri_L, dri_R, NN, Step)
% Esta função é responsavel por calculo da Jacobiana e guardar o movimento.
%
% -Inputs:
% DH_L, DH_R - DH de ambos os braços
% Q_L_i, Q_R_i - Ângulos do robô inicial
% dri_L, dri_R - É o movimento linear que queremos aplicar a cada braço
% Robot_Dim - Dimensões do robô
% NN - Número de iterações
% Step - String com o passo a ser realizado de momento
% 
% -Output:
% Q_L_f, Q_R_f - Ângulos do robô final
% AAA_L, AAA_R - Matriz 4-D com os movimentos de cada robô

% Quero que o movimento linear seja feito em um espaço de tempo menor que
% os outros movimentos, visto que cobrem uma pequena area de cada vez
NN = NN/5;

% Braço esquerdo
dr_L = dri_L/NN;

for i = 1:NN
    MDH = GenerateMultiDH(DH_L,Q_L_i);
    AA = Tlinks(MDH(:,:,1));
    Ji = JacobianGeom(AA);
   
    % temp(:,i) = Q_L_i
   
    % É necessario fazer pinv pois a Ji não é quadrada
    dq = pinv(Ji)*dr_L;
    Q_L_f = Q_L_i + dq;
    
    % Verificar se os angulos ficam dentro dos limites das juntas
    for j = 3:size(Q_L_f,1)
        if mod(j,2) ~= 0
            if Q_L_f(j) > pi || Q_L_f(j) < -pi 
                error("Pelo menos um ângulo do braço esquerdo fica fora dos limites durante o passo: " + Step)
            end
        else
            if Q_L_f(j) > 3*pi/4 || Q_L_f(j) < -3*pi/4
                error("Pelo menos um ângulo do braço esquerdo fica fora dos limites durante o passo: " + Step)
            end
        end
    end

    MQ_L(:,i) = LinspaceVect(Q_L_i, Q_L_f, 1);
    Q_L_i = Q_L_f;
end

% Braço direito
dr_R = dri_R/NN;

for i = 1:NN
    MDH = GenerateMultiDH(DH_R,Q_R_i);
    AA = Tlinks(MDH(:,:,1));
    Ji = JacobianGeom(AA);

    dq = pinv(Ji)*dr_R;

    Q_R_f = Q_R_i + dq;
    
    % Verificar se os angulos ficam dentro dos limites das juntas
    for j = 3:size(Q_R_f,1)
        if mod(j,2) ~= 0
            if Q_R_f(j) > pi || Q_R_f(j) < -pi
                error("Pelo menos um ângulo do braço direito fica fora dos limites durante o passo: " + Step)
            end
        else
            if Q_R_f(j) > 3*pi/4 || Q_R_f(j) < -3*pi/4
                error("Pelo menos um ângulo do braço direito fica fora dos limites durante o passo: " + Step)
            end
        end
    end

    MQ_R(:,i) = LinspaceVect(Q_R_i, Q_R_f, 1);
    Q_R_i = Q_R_f;
end


MDH_L = GenerateMultiDH(DH_L, MQ_L);
AAA_L = CalculateRobotMotion(MDH_L);
AAA_L(:,:,:,NN+1:NN*5) = zeros(4,4,9,NN*5-NN);

MDH_R = GenerateMultiDH(DH_R, MQ_R);
AAA_R = CalculateRobotMotion(MDH_R);
AAA_R(:,:,:,NN+1:NN*5) = zeros(4,4,9,NN*5-NN);

end