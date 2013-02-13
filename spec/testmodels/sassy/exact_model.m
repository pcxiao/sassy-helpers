function dydt = f(t,y,p)

% --------------------------------------------------------------------------
%
%           Oscillator with exact limit cycle solution
%           This is equivalent to Rdot = 2(tau1-R)R; phidot = -1/alpha
%           where R = r^2
%
% --------------------------------------------------------------------------


eval(p);

%tau1 = tau / (2 * pi);
%tau1 = tau;
r2 = (y(1) * y(1)  + y(2) * y(2));
     
dydt = [            
     y(2) / omega + tau * y(1) - y(1) * r2;
    -y(1) / omega  + tau * y(2) - y(2) * r2;
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
%%%info 
%%%force_type noforce
% =======================================================================


