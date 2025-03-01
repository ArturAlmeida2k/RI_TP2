function TapeteCircle(r,l,h,c,x,y,z)
% Esta função faz parte da DrawTable, serve para desenhar as bordas dos
% tapetes
%
% -Inputs:
% Dimenções da mesa

num_circ_points = 100; 
raio = r; 
theta = linspace(0, 2*pi, num_circ_points); 

rx = raio * cos(theta); 
rz = raio * sin(theta); 

x_d = rx(rx <= 0);
z_d = rz(rx <= 0) + h;

x_e = x_d*-1;
z_e = z_d*-1;

cy =[0 l];
P = [];
for j = 1:2
    for i = 1:size(x_d,2)
        newP = [x_d(i) cy(j) z_d(i)];
        P = [P
             newP];
    end
end

P_e = htrans(c+x,y,h*2+z) * hroty(pi) * [P';ones(1,size(P,1))] ;
P = htrans(x,y,z) * [P';ones(1,size(P,1))];


F = [];
for i = 2:size(x_d,2)
    newFace = [i-1 i size(x_d,2)+i size(x_d,2)+i-1];
    F = [F
         newFace];
end

CF = [];
for i = 1:size(x_d,2)
    CF = [CF i];
end
temp = [];
for i = 1:size(x_d,2)
    temp = [i temp];
end
CF = [CF temp];

patch("Vertices", P(1:3,:)' , "Faces", F, "FaceColor", "g", "EdgeColor", "none");
patch("Vertices", P(1:3,1:size(P,2)/2)' , "Faces", CF, "FaceColor", "g");
patch("Vertices", P(1:3,size(P,2)/2+1:size(P,2))' , "Faces", CF, "FaceColor", "g");

patch("Vertices", P_e(1:3,:)' , "Faces", F, "FaceColor", "g", "EdgeColor", "none");
patch("Vertices", P_e(1:3,1:size(P_e,2)/2)' , "Faces", CF, "FaceColor", "g");
patch("Vertices", P_e(1:3,size(P_e,2)/2+1:size(P_e,2))' , "Faces", CF, "FaceColor", "g");
