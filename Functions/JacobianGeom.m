function J = JacobianGeom(AA, jTypes)
N=size(AA,3); %numberofjoints
if nargin<2 %iffewarguments
    jTypes=0;
end
if numel(jTypes)<2 %ifnotavector
    jTypes=zeros(N,1);
end
Zis= JointAxes(AA); %thejointaxes
Org= LinkOrigins(AA);%thelinkorigins
ON=Org(:,end); % TCP(lastsystem)

for i=1:N %foreachjoint...
    Oi=Org(:,i); %...getitsorigin
    Zi=Zis(:,i); %...getitszaxis
    if i <= 2
        Jvi = [0 0 0];
        Jwi = [0 0 0];
    else %rotational
        Jvi=cross(Zi, ON-Oi);
        Jwi=Zi;
    end
    Jv(:,i)=Jvi; %setJvcomponent
    Jw(:,i)=Jwi; %setJwcomponent
end
J=[Jv;Jw];
end