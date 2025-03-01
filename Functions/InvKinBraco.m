function Qout = InvKinBraco(x, y, z, Robot_Dim, J0, d, Step)
% Esta função vai calcular os ângulos θ1 θ2 θ4 com base no ponto fornecido.
%
% -Inputs:
% x, y, z - Ponto de aproximação
% Robot_Dim - Dimensões do robô
% J0 - Tem o valor de 0 ou pi e define para que lado o robo estará virado 
% d - Se é o braço direito tem valor de 1 
% Step - String com o passo a ser realizado de momento
%
% -Outputs:
% Qout - Ângulos calculados

H = Robot_Dim(1);
LX = Robot_Dim(3);
LA = Robot_Dim(4);
LB = Robot_Dim(5);
LC = Robot_Dim(6);
LD = Robot_Dim(7);

% A z é retirado LD porque o pulso vai estar virado para baixo
PWx = x;
PWy = y;
PWz = z + LD;

% Foram feitos os calculos para a cinematica inversa e a unica diferença
% entre braço esquerdo e o direito são as que se encontram a seguir assim
% como a diferença entre estar virado para a frente ou para tras
if d == 1 
    PWx = -PWx;
    LX = -LX;
    PWy = -PWy;
    PWz = -PWz;
    H = -H;
end
if J0 == pi 
    PWx = -PWx;
    PWy = -PWy;
end

q4 = acos(((PWx-LX)^2+(PWy+LA)^2+(PWz-H)^2-LB^2-LC^2)/(2*LB*LC));
if ~isreal(q4)
    if d == 0
        error("Bloco 1 fora da área de trabalho durante o passo: " + Step)
    else 
        error("Bloco 2 fora da área de trabalho durante o passo: " + Step)
    end
end
q4 = [q4 -q4];

r = sqrt(LC^2*sin(q4).^2 + (-LC*cos(q4)-LB).^2 - (PWy+LA)^2);

q2A = 2*atan((LC*sin(q4) + r) ./ (-LC*cos(q4)-LB+PWy+LA));
q2B = 2*atan((LC*sin(q4) - r) ./ (-LC*cos(q4)-LB+PWy+LA));

q2 =[q2A q2B];


k = LC*sin(q2+[q4 q4]) + LB*sin(q2);
q1 = atan2((PWz-H)*sign(k), (PWx-LX)*sign(k));

Q = [q1
     q2
     0 0 0 0
     q4 q4];

Qout = [];

% Aqui é verificado se os ângulos obtidos estão dentro dos limites ou não
for i = 1:size(Q,2)
    if Q(1,i) < pi && Q(1,i) > -pi && Q(2,i) < 3*pi/4 && Q(2,i) > -3*pi/4 && Q(4,i) < 3*pi/4 && Q(4,i) > -3*pi/4
       Qout = [Qout Q(:,i)];
    end
end
if isempty(Qout)
    if d == 0
        error("Todos as combinações dos ângulos possiveis para o braço esquerdo estão fora do limte de juntas durante o passo: " + Step)
    else 
        error("Todos as combinações dos ângulos possiveis para o braço direito estão fora do limte de juntas durante o passo: " + Step)
    end
end

% É escolhido o "set" de ângulos que implica menor movimento
Csum = sum(abs(Qout),1);
[~,n] = min(Csum);
Qout = Qout(:,n);


end