function RollingCylinder(r,l,x,y,z)
% Esta função faz parte da DrawTable, serve para desenhar os cilindros no
% meio dos tapetes
%
% -Inputs:
% Dimenções da mesa

num_circ_points = 100; 
raio = r; 
theta = linspace(0, 2*pi, num_circ_points); 

rx = raio * cos(theta); 
rz = raio * sin(theta); 

cy = [0 l];
P = [];
for j = 1:2
    for i = 1:size(rx,2)
        newP = [rx(i) cy(j) rz(i)];
        P = [P
             newP];
    end
end

P = htrans(x,y,z) * [P';ones(1,size(P,1))];

F = [];
for i = 2:size(rx,2)
    newFace = [i-1 i size(rx,2)+i size(rx,2)+i-1];
    F = [F
         newFace];
end

CF = [];
for i = 1:size(rx,2)
    CF = [CF i];
end

TableColor = [172/255, 178/255, 235/255];

patch("Vertices", P(1:3,:)' , "Faces", F, "FaceColor", TableColor, "EdgeColor", "none");
patch("Vertices", P(1:3,1:size(P,2)/2)' , "Faces", CF, "FaceColor", TableColor);
patch("Vertices", P(1:3,size(P,2)/2+1:size(P,2))' , "Faces", CF, "FaceColor", TableColor);
