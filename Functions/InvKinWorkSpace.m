function InvKinWorkSpace(x, y, z, Robot_Dim, J0, d, Step)
% Esta função vai usar a cinemática inversa do braço para ver se a mesa final está dentro da área de trabalho
%
% -Inputs:
% x, y, z - Ponto de aproximação
% Robot_Dim - Dimensões do robô
% J0 - Tem o valor de 0 ou pi e define para que lado o robo estará virado 
% d - Se é o braço direito tem valor de 1 
% Step - String com o passo a ser realizado de momento

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
    error(Step + " fora da área de trabalho.")
end
end