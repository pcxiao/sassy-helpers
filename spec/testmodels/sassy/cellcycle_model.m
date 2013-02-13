% Automatically converted model file: leloup03

function dydt = f(t, y, p)
   
% Herzel Mammalian Clock model equations

eval(p);    
   
dydt = [  
      % y(1) = Md
      (    vsd*(GF/(Kgf+GF))        ...
        -  vdd*(y(1)/(Kdd + y(1)))  ...
      ) * eps_par ; 
      
      % y(2) = E2F
      (    V1e2f*((E2Ftot - y(2)) / (K1e2f + (E2Ftot - y(2))) ) * ( y(1) + y(3) ) ...
        -  V2e2f*y(4)*(y(2) / (K2e2f + y(2))) ...
      ) * eps_par;
       
      % y(3) = Me
      (    V1Me*y(1)*(a+b1*y(3))*( ( Metot - y(3) ) / (K1me + (Metot - y(3)) ) )...
        -  V2Me*y(4)*(y(3) / (K2me + y(3)) ) ...
      ) * eps_par; 
      
      % y(4) = Ma
      (    V1Ma*y(2)*( ( Matot - y(4) ) / (K1ma + ( Matot - y(4) ) ) ) ...
        -  V2Ma*y(6)*( y(4)/(K2ma + y(4)) )   ...
      ) * eps_par;
      
      % y(5) = Mb
      (    V1Mb*y(4)*(a+b2*y(5))*( Kie / ( Kie + y(3) ) )*( ( Mbtot - y(5) ) / (K1mb + (Mbtot - y(5))) ) ...
        -  V2Mb*(Kib/(Kib+y(4)))*y(6)*( y(5)/(K2mb + y(5)) )   ...
      ) * eps_par;
      
      % y(6) = Cdc20 (called APC in stochastic model)
      (    V1apc * y(5) * ( (APCtot - y(6)) / (K1apc + ( APCtot - y(6) ) ) )...
        -  V2apc * (y(6)/(K2apc + y(6)))  ...
      )*eps_par;
];

% =======================================================================
% the information below is written into the file name.info and is used to
% comeps_parnicate whether the system is an oscillator or a signalling system,
% which ode solver method to use, the end time is teh system is a signal,
% the force type used from the file /shared/theforce and wherther the
% solutions should be non-negative or not. The %%% before
% each line is needed. Using %%%info lines it can also be used to store away
% other information. In this case the title of the model and the initial
% condition that is used.
%%%info Goldbeter Leloup Cell cycle mode
%%%force_type noforce
% =======================================================================
