addpath Funcoes
addpath Funcoes/Funcoes_igual_aula
clc
clear
close all

% Pedido de parametros ao utilizador
file = 'tp2.txt';
n_blocos = input("Número de blocos a apanhar: ");
n_pp = input("Número de vezes que deseja ver o trajeto: ");

if n_pp > n_blocos
    n_pp = n_blocos;
    disp("Serão consideradas " + n_pp + " vezes para ver o trajeto.")
end

[LTF, LTT, SideL, SideH, DS, LegC, LegL, HTA, HTB, HTC, DTF, DTT, WTS, STF, LBL, WBL, HBL, H, LX, LZ, LA, LB, LC, LD] = ReadValues(file);

figure("WindowStyle","docked") 
 
% Dar o offset da curvatura do robô as mesas 
DTF = DTF + LX; 
DTT = DTT - LX;

% Desenhar as mesas usando as dimenções definidas
DrawTable(LTF, SideL, SideH, DS, LegC, LegL, DTF, STF/2, HTA, WTS, 1) %mesa 1
DrawTable(LTF, SideL, SideH, DS, LegC, LegL, DTF, STF/2, HTB, WTS, 2) %mesa 2
DrawTable(LTT, SideL, SideH, DS, LegC, LegL, DTT, 0, HTC, WTS, 3) %mesa 3

hold on;
grid on;
axis equal;
view(135, 30)
y = max(STF/2+WTS+DS*2+SideL*2, (LA+LB+LC+LD)*1.1);
axis([-(DTT+LTT*1.1) DTF+LTF*1.1 -y y 0 H+200])

% Usado para melhor passar as dimenções do robô entre funções
Robot_Dim = [H, LZ, LX, LA, LB, LC, LD];

NN = 100; % tem de ser multiplo de 5

% Matriz DH do braço esquerdo
DH_L = [0  0  H-LZ 0   % 0
        0  LX LZ  pi/2 % J0 [pi -pi]
        0  0  LA -pi/2 % θ1 [pi -pi]
        0  0  0   pi/2 % θ2 [3/4*pi -3/4*pi]
        0  0  LB -pi/2 % θ3 [pi -pi]
        0  0  0   pi/2 % θ4 [3/4*pi -3/4*pi]
        0  0  LC -pi/2 % θ5 [pi -pi]
        0  0  0   pi/2 % θ6 [3/4*pi -3/4*pi]
        0  0  LD  0];  % θ7 [pi -pi]

% Matriz DH do braço direito
DH_R = [0  0  H-LZ 0   % 0
        0  LX LZ  pi/2 % J0 [pi -pi]
        0  0 -LA -pi/2 % θ1 [pi -pi]
        0  0  0  -pi/2 % θ2 [3/4*pi -3/4*pi]
        0  0  LB  pi/2 % θ3 [pi -pi]
        0  0  0  -pi/2 % θ4 [3/4*pi -3/4*pi]
        0  0  LC  pi/2 % θ5 [pi -pi]
        0  0  0  -pi/2 % θ6 [3/4*pi -3/4*pi]
        0  0  LD  0];  % θ7 [pi -pi]

% Obter pontos necessarios dos eixos e garra para fazer patchs
[P_E,F_E] = seixos3(100);
[P_G,F_G] = Garra(1);

% Desenhar o robô a Zero Hardware
[h_M, h_L, h_R, H_M, H_L, H_R, AA_M] = InitRobot(DH_L, DH_R, P_E, F_E, P_G, F_G);
pause(0.5)
% Verificar se o lugar de pousar os blocos na mesa final se encontra dentro
% do espaço de trabalho
InvKinWorkSpace(-DTT, LBL/2, HTC + HBL, Robot_Dim, pi, 0, "Mesa Final")

Q_L = zeros(1,9);
Q_R = zeros(1,9);
AAA_L_T = zeros(4,4,size(DH_L,1),NN,11); 
AAA_R_T = zeros(4,4,size(DH_R,1),NN,11);


% Dentro deste "for" será quardado o movimento do robô para ser percorrido
% no fim.
for i = 1:n_blocos % Número de blocos
    % Se p for 1 desenha a previsão do caminho e o trajeto do end-factor 
    if i <= n_pp
        p = 1;
    else
        p = 0;
    end
    
    % Inicializar os Blocos
    [h_B1, h_B2, P_B, y_B1, y_B2, angle_B1, angle_B2] = InitBlocks(WBL, LBL, HBL, STF, WTS, DS, SideL);

    % Colocar os blocos fora de visão temporariamente
    MAnimate(h_B1, P_B, eye(4), htrans(0, 0, -100), 1);
    MAnimate(h_B2, P_B, eye(4), htrans(0, 0, -100), 1);
    
    % Para caso de erro mostrar a localização dos blocos
    plot3(DTF, -y_B1, HTA+HBL, "X", "LineWidth", 2, "Color", "r", "Tag", "block" )
    plot3(DTF,  y_B2, HTB+HBL, "X", "LineWidth", 2, "Color", "b", "Tag", "block" )

    % Pontos HBL unidades a cima de cada bloco
    Ponto_E = [DTF -y_B1  HTA+HBL*2];
    Ponto_D = [DTF  y_B2  HTB+HBL*2];

    J0 = 0;

    Step = "Posicionar garra sobre os blocos";
    [Q_L, Q_R, AAA_L_T(:,:,:,:,1), AAA_R_T(:,:,:,:,1)] = InvKinMov(Robot_Dim, DH_L, DH_R, Ponto_E, Ponto_D, Q_L, Q_R, NN, J0, angle_B1, angle_B2, Step);

    dr = [0 0 -HBL 0 0 0]';

    Step = "Descer a garra para agarrar os blocos";
    [Q_L, Q_R, AAA_L_T(:,:,:,:,2), AAA_R_T(:,:,:,:,2)] = JacobianMov2(DH_L, DH_R, Q_L, Q_R, dr, dr, NN, Step);

    dr = [0 0 HBL 0 0 0]';

    Step = "Subir a garra com os blocos";
    [Q_L, Q_R, AAA_L_T(:,:,:,:,3), AAA_R_T(:,:,:,:,3)] = JacobianMov2(DH_L, DH_R, Q_L, Q_R, dr, dr, NN, Step);

    Ponto_E = [DTT+WBL/2  -LBL  H-LD];
    Ponto_D = [DTT+WBL/2   LBL  H-LD];

    J0 = 0;
    angle = pi;
   
    Step = "Posicionar a garra e os blocos de maneira a serem juntos";
    [Q_L, Q_R, AAA_L_T(:,:,:,:,4), AAA_R_T(:,:,:,:,4)] = InvKinMov(Robot_Dim, DH_L, DH_R, Ponto_E, Ponto_D, Q_L, Q_R, NN, J0, angle, angle, Step);

    dr_L = [0  LBL/2 0 0 0 0]';
    dr_R = [0 -LBL/2 0 0 0 0]';

    Step = "Juntar os 2 blocos";
    [Q_L, Q_R, AAA_L_T(:,:,:,:,5), AAA_R_T(:,:,:,:,5)] = JacobianMov2(DH_L, DH_R, Q_L, Q_R, dr_L, dr_R, NN, Step);
    
    Step = "Rodar o robo 180º";
    [Q_L, Q_R, AAA_L_T(:,:,:,:,6), AAA_R_T(:,:,:,:,6)] = J0Mov(DH_L, DH_R, Q_L, Q_R, pi, NN);

    dr_L = [0 0 -(H-LD-HTC-HBL*2) 0 0 0]';
    dr_R = [0 0 -(H-LD-HTC-HBL*2) 0 0 0]';
    
    Step = "Aproximar a garra e os blocos do tapete final";
    [Q_L, Q_R, AAA_L_T(:,:,:,:,7), AAA_R_T(:,:,:,:,7)] = JacobianMov2(DH_L, DH_R, Q_L, Q_R, dr_L, dr_R, NN, Step);

    dr = [0 0 -HBL 0 0 0]';

    Step = "Descer a garra e os blocos para os largar no tapete final";
    [Q_L, Q_R, AAA_L_T(:,:,:,:,8), AAA_R_T(:,:,:,:,8)] = JacobianMov2(DH_L, DH_R, Q_L, Q_R, dr, dr, NN, Step);

    dr = [0 0 HBL 0 0 0]';

    Step = "Subir a garra sem os blocos";
    [Q_L, Q_R, AAA_L_T(:,:,:,:,9), AAA_R_T(:,:,:,:,9)] = JacobianMov2(DH_L, DH_R, Q_L, Q_R, dr, dr, NN, Step);
    
     
    Ponto_E = [-(LC+LX)  LA+LB  H-LD];
    Ponto_D = [-(LC+LX) -(LA+LB)  H-LD];

    J0 = pi;
    angle = 0;

    Step = "Subir as garras para apanhar os proximos blocos antes de virar";
    [Q_L, Q_R, AAA_L_T(:,:,:,:,10), AAA_R_T(:,:,:,:,10)] = InvKinMov(Robot_Dim, DH_L, DH_R, Ponto_E, Ponto_D, Q_L, Q_R, NN, J0, angle, angle, Step);

    Ponto_E = [LC+LX -(LA+LB)  H-LD];
    Ponto_D = [LC+LX   LA+LB  H-LD];

    J0 = 0;
    angle = 0;
    
    Step = "Posicionar o robo e as garras para apanhar os proximos blocos";
    [Q_L, Q_R, AAA_L_T(:,:,:,:,11), AAA_R_T(:,:,:,:,11)] = InvKinMov(Robot_Dim, DH_L, DH_R, Ponto_E, Ponto_D, Q_L, Q_R, NN, J0, angle, angle, Step);
    
    % Eliminar os pontos dos blocos porque não deu erro
    block = findobj(gca, "Tag", "block");
    delete(block)

    AnimateRobot(H_L,H_R,H_M,AAA_L_T,AAA_R_T,P_E,P_G,h_L,h_R,h_M,AA_M,0.005,p,h_B1, h_B2, P_B, DTF, LTF, LTT, y_B1, y_B2, HTA, HTB, angle_B1, angle_B2);
    
    % Pausa entre blocos
    pause(1)
    % Elimina o movimento do end-factor
    mov = findobj(gca, "Tag", "mov");
    delete(mov)
end