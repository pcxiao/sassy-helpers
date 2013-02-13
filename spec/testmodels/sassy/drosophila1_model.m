function dydt = f(t, y, p)
   
eval(p);    
   
dydt = [ 
    % mRNA 1
    vs * ki^n / (y(5)^n + ki^n) - vm * y(1)/(y(1) + km); 

    % Prot 2
    ks * y(1) - v1 * y(2) /(y(2) + k1) + v2 * y(3) / (y(3) + k2); 

    % PER-p1 3
    v1*y(2) / (y(2) + k1)-v2 * y(3) / (y(3) + k2) - ...
    v3 * y(3) / (y(3) + k3) + v4 * y(4) / (y(4) + k4); 

    % PER-p2 4
    v3*y(3) / (y(3) + k3) - v4 * y(4) / (y(4) + k4) - ...
    k1k * y(4)  + k2k * y(5) - vd * y(4) / (y(4) + kd);

    % Pc5
    k1k * y(4)  - k2k * y(5);
    
];

% =======================================================================
% the information below is written into the file name.info and is used to
% communicate whether the system is an oscillator or a signalling system,
% which ode solver method to use, the end time is teh system is a signal,
% the force type used from the file /shared/theforce and wherther the
% solutions should be non-negative or not. The %%% before
% each line is needed. Using %%%info lines it can also be used to store away
% other information. In this case the title of the model and the initial
% condition that is used.
%%%info Goldbeter original drosophila with PER only without TIM
%%%force_type noforce

% =======================================================================



