function Tlast = MAnimate(h, P, Tcurr, Tset, ord)

%h - handle do objeto
%P - pontos do objeto (homog.)
%Tcurr - matriz (4x4) da posição de partida
%Tset - hipermatroz (4x4xN) N marizes para fazzer animação
%ord - ordem de transf. 1=local (pós-mult) 0-global (pre-mul)

for n=1:size(Tset,3)
    if ord == 1
        T = Tcurr*Tset(:,:,n);
    else
        T = Tset(:,:,n)*Tcurr;
    end
    Q = T*P;
    h.Vertices = Q(1:3,:)';
end

Tlast = T;

end