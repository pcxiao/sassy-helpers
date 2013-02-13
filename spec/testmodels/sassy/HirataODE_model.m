function dydt = f(t,y,p)

eval(p);

dydt = [
        -mu1 * y(1) + p1 / (1 + y(2)^2);
        -mu2 * y(2) + p2 * y(1) - k1 * y(2) * y(3);
         -mu3 * y(3) + p3 / (1 + y(2)^2) - k1 * y(2) * y(3);
        ];