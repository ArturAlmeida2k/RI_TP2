function DrawTable(LT, SideL, SideH, DS, LegC, LegL, DT, STF_r, HT, WTS, M)
% Esta função vai desenhar a as mesas para a simulação
% Usa 2 funções adicionais (TapeteCircle, RollingCylinder) para desenhar
% algumas partes da mesa.
%
% -Inputs:
% Dimenções da mesa
% M - Qual mesa a ser desenhada

SC = LT*1.1; 

LegH = HT - SideH;

% As direntes mesas precisam de ter cuidados diferentes na posição delas
if M == 1
    x = DT;
    y = -STF_r - DS*2 - WTS - SideL*2;
    z = HT;
elseif M == 2
    x = DT;
    y = STF_r;
    z = HT;
else
    x = -DT-LT;
    y = -WTS/2-DS-SideL;
    z = HT;
end

left_side = [0  0  0
             SC 0  0
             0  SideL 0
             SC SideL 0
             0  0  SideH
             SC 0  SideH
             0  SideL SideH
             SC SideL SideH];

LS = htrans(x-(SC-LT)/2,y,z-SideH) * [left_side';ones(1,size(left_side,1))];
RS = htrans(0 ,SideL + WTS + DS * 2 ,0) * LS;

FS = [1 2 4 3
      1 3 7 5
      1 2 6 5
      5 6 8 7
      2 4 8 6
      3 4 8 7];

tapete = [0   0  0
          LT  0  0
          0  WTS 0
          LT WTS 0
          0   0  0
          LT  0  0
          0  WTS 0
          LT WTS 0];

T1 = htrans(x,y+SideL+DS,z) * [tapete';ones(1,size(tapete,1))];
T2 = htrans(0,0,-SideH) * T1;

legPoints = [0    0     0
             LegL 0     0
             0    LegC  0
             LegL LegC  0
             0    0    -LegH
             LegL 0    -LegH
             0    LegC -LegH
             LegL LegC -LegH] ;

LP1 = htrans(x,y,LegH) * [legPoints';ones(1,size(legPoints,1))];
LP2 = htrans(0,SideL*2+WTS+DS*2-LegC,0) * LP1;
LP3 = htrans(LT-LegL,0,0) * LP1;
LP4 = htrans(0,SideL*2+WTS+DS*2-LegC,0) * LP3;


TableColor = [172/255, 178/255, 235/255];

patch("Vertices", LS(1:3,:)' , "Faces", FS, "FaceColor", TableColor);
patch("Vertices", RS(1:3,:)' , "Faces", FS, "FaceColor", TableColor);
patch("Vertices", T1(1:3,:)' , "Faces", FS, "FaceColor", "g");
patch("Vertices", T2(1:3,:)' , "Faces", FS, "FaceColor", "g");
patch("Vertices", LP1(1:3,:)' , "Faces", FS, "FaceColor", TableColor);
patch("Vertices", LP2(1:3,:)' , "Faces", FS, "FaceColor", TableColor);
patch("Vertices", LP3(1:3,:)' , "Faces", FS, "FaceColor", TableColor);
patch("Vertices", LP4(1:3,:)' , "Faces", FS, "FaceColor", TableColor);

TapeteCircle(SideH/2,WTS,SideH/2,LT,x,y+SideL+DS,z-SideH);
 
RollingCylinder(SideH/2*0.90,WTS+DS*2,x,y+SideL,z-SideH/2);
if LT/WTS > 2
    RollingCylinder(SideH/2*0.90,WTS+DS*2,x+LT/3,y+SideL,z-SideH/2);
    RollingCylinder(SideH/2*0.90,WTS+DS*2,x+LT/3*2,y+SideL,z-SideH/2);
else 
    RollingCylinder(SideH/2*0.90,WTS+DS*2,x+LT/2,y+SideL,z-SideH/2);
end
RollingCylinder(SideH/2*0.90,WTS+DS*2,x+LT,y+SideL,z-SideH/2);
