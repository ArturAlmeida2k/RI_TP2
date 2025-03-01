function [LTF, LTT, SideL, SideH, DS, LegC, LegL, HTA, HTB, HTC, DTF, DTT, WTS, STF, LBL, WBL, HBL, H, LX, LZ, LA, LB, LC, LD] = ReadValues(file)
% Define os valores base para cada dimenção da simulação 
% Lê os valores das dimenções num ficheiro 


LTF = 1604; %comprimento mesa frontal
LTT = 1104; %comprimento mesa traseira

SideL = 50; %largura bordas mesas
SideH = 100; %altura bordas mesas
DS = 25; %espaço entre bordas e tapete (deadspace)
LegC = 50; %comprimento pernas
LegL = 100; %largura pernas

HTA = 804; %altura mesa 1
HTB = 704; %altura mesa 2
HTC = 804; %altura mesa 3
DTF = 433; %distacia mesa frontal
DTT = 691; %distancia mesa traseira
WTS = 600; %largura mesas
STF = 219; %espaçamento entre mesas

LBL = 150; % cumprimento bloco
WBL = 40; % largura bloco
HBL = 50; % altura bloco

% Dimensões do robõ
H = 1223;
LX = 125; 
LZ = 332;
LA = 295;
LB = 340;
LC = 335;
LD = 194;

try
    tfid = fopen(file);
    tdata = textscan(tfid,'%s=%s');
    fclose(tfid);
    if( numel(tdata{1}) ~= numel(tdata{2}))
        disp('Error reading file. Missing = !')
        clear tdata tfid
    else
        ndata={ tdata{1} repmat('=', size(tdata{1})) tdata{2}};
        sdata=strcat(ndata{1},ndata{2},ndata{3});
        for i=1:numel(sdata)
            try
                eval(sdata{i})
            catch
                sprintf('Bad format in line %d of data file!',i)
            end
        end
        clear i tfid ndata tdata sdata
    end
catch
    disp('Cannot open file.')
end

end