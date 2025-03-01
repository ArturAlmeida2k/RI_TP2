function AnimateRobot(H_L,H_R,H_M,AAA_L,AAA_R,P_E,P_G,h_L,h_R,h_M,AA_M,sd,pp,h_B1, h_B2, P_B, DTF, LTF, LTT, y_B1, y_B2, HTA, HTB, angle_B1, angle_B2)
% Esta função vai fazer o movimento do robô usando os movimentos guardados
% para fazer o trajeto.
%
% -Inputs:
% H_M - Array de handles graficos do tronco do robô
% H_L - Array de handles graficos do braço esquerdo
% H_R - Array de handles graficos do braço direito
% AAA_L - Movimentos do braço esquerdo
% AAA_R - Movimentos do braço direito
% P_E - Pontos dos eixos
% P_G - Pontos da garra
% h_M - Linhas do tronco do robô
% h_L - Linhas do braço esquerdo
% h_R - Linhas do braço direito
% AA_M -Set de G.T. do troco do robô
% sd - Tempo de pausa
% pp - Se desenha o end-factor e a previsão do movimento
% h_B1 - Patch do blocos 1
% h_B2 - Patch do blocos 2
% P_B - Pontos do bloco
% DTF - Distancia mesas frontal
% LTF - Comprimento mesas frontais
% LTT - Comprimento mesa traseira
% y_B1 - A posição y do bloco 1
% y_B2 - A posição y do bloco 2
% angle_B1 - Ângulo do bloco 1
% angle_B2 - Ângulo do bloco 2

% Vai correr por todos os movimentos guardados
for i = 1:size(AAA_L,5)
    % Se pp for 1 mostra a previsão do movimento
    if pp
        MovPrev(AAA_L(:,:,:,:,i), AAA_R(:,:,:,:,i))
        pause(0.5)
    end
    % Se for o 1º movimento tambem serão movidos os blocos no tapete
    if i == 1
        T =  mhtrans(DTF+LTF, -y_B1, HTA) * mhrotz(angle_B1);
        Tcurr_B1 = MAnimate(h_B1, P_B, eye(4), T, 1);

        T =  mhtrans(DTF+LTF, y_B2, HTB) * mhrotz(angle_B2);
        Tcurr_B2 = MAnimate(h_B2, P_B, eye(4), T, 1);

        Tset = mhtrans(linspace(0, -LTF, size(AAA_L, 4)), 0, 0);
    
    % Se for o 9ª movimento guarda a posiçao do enfactor para ser usado no
    % proximo movimento
    elseif i == 9
        Tcurr_B1 = T_L;
        Tcurr_B2 = T_R;
    
    % Se for o 10º movimento tambem serão movidos os blocos no tapete final
    elseif i == 10
        Tset = mhtrans(linspace(0, -LTT, size(AAA_L, 4)), 0, 0);
    end
    % Vai correr as varias iterações de cada movimento
    for n=1:size(AAA_L,4)
        AA_L = AAA_L(:,:,:,n,i);
        AA_R = AAA_R(:,:,:,n,i);
        % Caso esteja completamente vazio a iteração (acontece por causa do
        % jacobiano ser feito em menos iterações e ser necessario da "pad")
        if AA_L(:,:,:) == 0
            continue
        end
        % Fazer o movimento dos blocos nos tapetes
        if i == 1 || i == 10
            T_B1 = Tset(:,:,n) * Tcurr_B1;
            T_B2 = Tset(:,:,n) * Tcurr_B2;

            Q_B1 = T_B1*P_B;
            Q_B2 = T_B2*P_B;

            h_B1.Vertices = Q_B1(1:3,:)';
            h_B2.Vertices = Q_B2(1:3,:)';
        end

        Org_L = LinkOrigins(AA_L(:,:,2:size(AA_L,3)),AA_M);
        Org_R = LinkOrigins(AA_R(:,:,2:size(AA_R,3)),AA_M);
        Org_M = LinkOrigins(AA_R(:,:,1:2));
        h_L.XData = Org_L(1,:);
        h_L.YData = Org_L(2,:);
        h_L.ZData = Org_L(3,:);
        h_R.XData = Org_R(1,:);
        h_R.YData = Org_R(2,:);
        h_R.ZData = Org_R(3,:);
        h_M.XData = Org_M(1,:);
        h_M.YData = Org_M(2,:);
        h_M.ZData = Org_M(3,:);

        % Atualizar todos os sistemas de eixos
        T = eye(4);
        for j = 1:size(AAA_L,3) 
            % Atualiza apenas o tronco
            if j == 1
                T = T * AAA_L(:,:,1,n,i);
                T_L = T;
                T_R = T;
                Q_M = T_L*P_E;
                H_M{j}.Vertices = Q_M(1:3,:)';
            % Atualiza os braços 
            elseif j ~= size(AAA_L,3)
                T_L = T_L*AAA_L(:,:,j,n,i);
                T_R = T_R*AAA_R(:,:,j,n,i);
                Q_L = T_L*P_E;
                Q_R = T_R*P_E;
                H_L{j-1}.Vertices = Q_L(1:3,:)';
                H_R{j-1}.Vertices = Q_R(1:3,:)';
                if j == 2
                    Q_M = T_L*P_E;
                    H_M{j}.Vertices = Q_M(1:3,:)';
                end
            % Atualiza a garra e o blocos caso estejam na garra
            else
                T_L = T_L*AAA_L(:,:,j,n,i);
                T_R = T_R*AAA_R(:,:,j,n,i);
                Q_L = T_L*P_G;
                Q_R = T_R*P_G;
                H_L{j-1}.Vertices = Q_L(1:3,:)';
                H_R{j-1}.Vertices = Q_R(1:3,:)';
                if i >= 3 && i <= 8
                    Q_B1 = T_L*P_B;
                    Q_B2 = T_R*P_B;
                    h_B1.Vertices = Q_B1(1:3,:)';
                    h_B2.Vertices = Q_B2(1:3,:)';
                end
            end
        end
        % Mostra o movimento do end-factor que já fez
        if pp
            plot3(T_L(1,4), T_L(2,4), T_L(3,4), ".", "Color", [1, 0.5, 0], "Tag", "mov" )
            plot3(T_R(1,4), T_R(2,4), T_R(3,4), ".", "Color", [1, 1, 0], "Tag", "mov" )
        end
        pause(sd)
    end
    % Elimina a previsão do movimento
    prev = findobj(gca, "Tag", "prev");
    delete(prev)
end
% Elimina os blocos
delete([h_B1 h_B2])

end