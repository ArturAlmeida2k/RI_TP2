function TT = mhrotz(v)
TT = zeros(4,4,numel(v));

for n=1:numel(v)
    TT(:,:,n)=hrotz(v(n));
end
end