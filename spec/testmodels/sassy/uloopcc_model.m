function dydt = f(t, y, p)

% Clock model based on dClock loop from Ueda drosophila 

eval(p);
dydt = [
    %CLKm 7
    c3 + (s5 + amp*force) * (1/(1+(y(4)/r3)^r+1))-d7*y(1)/(l7 + y(1))-d0 * y(1);
    
    %CLKc 8
    s6*y(1) - v3v * y(2) * cyc + v4*y(3) - (d8+0)*y(2)/(l8 +y(2))-d0*y(2);
    
    %CCc 9
    v3v * y(2)*cyc - v4*y(3) - t3 * y(3)/(k3 + y(3)) + t4 * y(4)/(y(4)+k4) - ...
    (d9+0)*y(3)/(l9+y(3))-d0 * y(3);
    
    %CCn 10
    (t3+0) * y(3)/(k3 + y(3)) - t4 * y(4)/(y(4)+k4) - d10*y(4)/(l10+y(4))-d0*y(4);

];

%dim

% =======================================================================
% the information below is written into the file name.info and is used to
% communicate whether the system is an oscillator or a signalling system,
% which ode solver method to use, the end time is teh system is a signal,
% the force type used from the file /shared/theforce and wherther the
% solutions should be non-negative or not. The %%% before
% each line is needed. Using %%%info lines it can also be used to store away
% other information. In this case the title of the model and the initial
% condition that is used.
%%%info 

% =======================================================================



