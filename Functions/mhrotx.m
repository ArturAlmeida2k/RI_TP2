function TT = mhrotx(v)
TT = zeros(4,4,numel(v));

for n=1:numel(v)
    TT(:,:,n)=hrotx(v(n));
end
end