function TT = mhtrans(vx,vy,vz)
m = max([numel(vx),numel(vy),numel(vz)]);
vx(end:m)=vx(end);
vy(end:m)=vy(end);
vz(end:m)=vz(end);

TT = zeros(4,4,m);

for n=1:m
    TT(:,:,n) = htrans(vx(n),vy(n),vz(n));
end
end