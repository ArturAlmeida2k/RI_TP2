function Qout = InvKinPulso(x, y, z, DH, Q, angle, d, Step)
% Esta função vai calcular os ângulos θ5 θ6 θ7 com base no ponto fornecido.
%
% -Inputs:
% x, y, z - Ponto de aproximação
% DH - DH do robô
% Q - Ângulos calculados anteriormente
% angle - Ângulo do bloco
% d - Se é o braço direito tem valor de 1 
%
% -Outputs:
% Qout - Ângulos calculados

thetas = [0 0 Q'];

T = eye(4); 

for i = 1:6
    A = hrotz(thetas(i)) * htrans(DH(i,2),0,DH(i,3)) * hrotx(DH(i,4));
    T = T * A;
end

R09 = hrotz(angle) * htrans(x, y, z)  * hrotx(pi);
R6a9 = inv(T)*R09;

if d == 0
    q5 = [atan2(R6a9(2,3)',R6a9(1,3)') atan2(-R6a9(2,3)',-R6a9(1,3)')];
else
    q5 = [atan2(-R6a9(2,3)',-R6a9(1,3)') atan2(R6a9(2,3)',R6a9(1,3)')];
end
q6 = [atan2(sqrt(R6a9(1,3)'.^2 + R6a9(2,3)'.^2), R6a9(3,3)') atan2(- sqrt(R6a9(1,3)'.^2 + R6a9(2,3)'.^2), R6a9(3,3)')];
q7 = [atan2(R6a9(3,2)', -R6a9(3,1)') atan2(-R6a9(3,2)', R6a9(3,1)')];

Q = [q5
    q6
    q7];

Qout = [];

% No pulso esquerdo é sempre escolhido o q5 negativo e no direito o q5
% positivo, isto é só porque fazem um movimento mais natural. Caso não
% exista esse ângulo tenta sem essa restrição
if d == 0
    for i = 1:size(Q,2)
        if Q(1,i) <= 0 && Q(1,i) >= -pi && Q(2,i) <= 3*pi/4 && Q(2,i) >= -3*pi/4 && Q(3,i) <= pi && Q(3,i) >= -pi
            Qout = [Qout Q(:,i)];
        end
    end
    if isempty(Qout)
        for i = 1:size(Q,2)
            if Q(1,i) <= pi && Q(1,i) >= -pi && Q(2,i) <= 3*pi/4 && Q(2,i) >= -3*pi/4 && Q(3,i) <= pi && Q(3,i) >= -pi
                Qout = [Qout Q(:,i)];
            end
        end
    end
else
    for i = 1:size(Q,2)
        if Q(1,i) <= pi && Q(1,i) >= 0 && Q(2,i) <= 3*pi/4 && Q(2,i) >= -3*pi/4 && Q(3,i) <= pi && Q(3,i) >= -pi
            Qout = [Qout Q(:,i)];
        end
    end
    if isempty(Qout)
        for i = 1:size(Q,2)
            if Q(1,i) <= pi && Q(1,i) >= -pi && Q(2,i) <= 3*pi/4 && Q(2,i) >= -3*pi/4 && Q(3,i) <= pi && Q(3,i) >= -pi
                Qout = [Qout Q(:,i)];
            end
        end
    end
end
if isempty(Qout)
    if d == 0
        error("Todos as combinações dos ângulos possiveis para o pulso esquerdo estão fora do limte de juntas durante o passo: " + Step)
    else 
        error("Todos as combinações dos ângulos possiveis para o puslo direito estão fora do limte de juntas durante o passo: " + Step)
    end
end
% É escolhido o "set" de ângulos que implica menor movimento
[~,n] = min(sum(abs(Qout),1));
% [~,n] = min(Qsum);
Qout = Qout(:,n);

end