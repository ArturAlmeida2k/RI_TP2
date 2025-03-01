function [J] = JacobianCalc(DH)

syms J0 t1 t2 t3 t4 t5 t6 t7 real;

thetas = [0, J0, t1, t2, t3, t4, t5, t6, t7];

T = eye(4); 

for i = 1:9
    A1 = hrotz(thetas(i)) * htrans2(DH(i,2),0,DH(i,3)) * hrotx(DH(i,4));
    T = T * A1;
end

x = T(1,4);
y = T(2,4);
z = T(3,4);

phi = simplify(atan(T(2,1)/T(1,1)));
psi = simplify(atan(T(3,2)/T(3,3)));
theta = simplify(atan(-T(3,1)/sqrt(T(1,1)^2+T(2,1)^2)));    

J=jacobian([x, y, z, phi, theta, psi],[t1 t2 t3 t4 t5 t6 t7]);

end