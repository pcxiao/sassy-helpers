function dydt = f(t, y, p)



% this is the right part of the model
% it is used by make (program which performs symbolic calculations)

%  t - time on time step
%  y - system variables on time step
%  p - declaration string from make function



% declare all variables parameters and variables below to be symbolic variables 
eval(p); 

dydt = [  
   (v1 + amp * force) / (1 + y(12)^4) - v2 * y(1) / (k2 + y(1));  
   v3*y(1) - lam*y(2);
   lam*y(2) - lam*y(3);
   lam*y(3) - lam*y(4);
   lam*y(4) - lam*y(5);
   lam*y(5) - lam*y(6);
   lam*y(6) - lam*y(7);
   lam*y(7) - lam*y(8);
   lam*y(8) - lam*y(9);
   lam*y(9) - lam*y(10);
   lam*y(10) - lam*y(11);
   lam*y(11) - v4*y(12);
];

                        
