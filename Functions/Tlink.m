function A = Tlink(th,l,d,alpha)
% Returns GT of link
A=hrotz(th)*htrans(l,0,d)*hrotx(alpha);
end