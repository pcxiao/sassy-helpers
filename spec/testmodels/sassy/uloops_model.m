function dydt = f(t, y, p)

% Two interlocked loops Drosophila tracking dawn and dusk 
% with Golbeter based PER-TIM loop and Ueda based dClock loop  
% tracks dawn and dusk separately

eval(p);

coupling1=coup*((y(10)/a1)^a + b1);
coupling2=a3*y(6)+b3;%((y(6)/a3)^a + b3);

dydt = [ 
    % per mRNA 1
    vsp * (kip^n+coupling1) / (y(10)^n + kip^n + coupling1) - vmp * y(1)/(y(1) + kmp) - kd * y(1); 

    % PER 2
    ksp * y(1) - v1p * y(2) /(y(2) + k1p) + v2p * y(3) / (y(3) + k2p) - kd * y(2); 

    % PER-p1 3
    v1p*y(2) / (y(2) + k1p)-v2p * y(3) / (y(3) + k2p) - ...
    v3p * y(3) / (y(3) + k3p) + v4p * y(4) / (y(4) + k4p) - kd * y(3); 

    % PER-p2 4
    v3p*y(3) / (y(3) + k3p) - v4p * y(4) / (y(4) + k4p) - ...
    k3 * y(4) * y(8) + k4 * y(9) - pvdp * y(4) / (y(4) + kdp) - kd * y(4);

    % tim mRNA 5
    vst * kit^n / (y(10)^n + kit^n) - vmt * y(5) / (y(5) + kmt) - kd * y(5);    

    % TIM 6
    kst * y(5) - v1t * y(6) / (y(6) + k1t) + v2t * y(7) / (y(7) + k2t) - kd * y(6);
    
    % TIM-p1 7
    v1t*y(6) / (y(6) + k1t) - v2t * y(7) / (y(7) + k2t) - ...
    v3t * y(7) / (y(7) + k3t) + v4t * y(8) / (y(8) + k4t) - kd * y(7);    
    
    % TIM-p2 8
    v3t*y(7) / (y(7) + k3t) - v4t * y(8)/(y(8)+ k4t) - ...
    k3*y(4) * y(8) + k4 * y(9) - (vdt + amp1 * amp * force) * y(8)/(y(8) + kdp) - kd * y(8);
    
    % PT 9
    k3 * y(4) * y(8) - k4 * y(9) - k1 * y(9) + k2 * y(10) - kdc * y(9);
    
    % PTn 10
    k1 * y(9) - k2 * y(10) - kdn * y(10);
    
    %CLKm 11
    c3 + (s5 + amp2* amp * force) * (coupling2/(1+(y(14)/r3)^r+coupling2))-d7*y(11)/(l7 + y(11))-d0 * y(11);
    
    %CLKc 12
    s6*y(11) - v3v * y(12) * cyc + v4*y(13) - (d8+0)*y(12)/(l8 +y(12))-d0*y(12);
    
    %CCc 13
    v3v * y(12)*cyc - v4*y(13) - t3 * y(13)/(k3cc + y(13)) + t4 * y(14)/(y(14)+k4cc) - ...
    (d9+0)*y(13)/(l9+y(13))-d0 * y(13);
    
    %CCn 14
    (t3+0) * y(13)/(k3cc + y(13)) - t4 * y(14)/(y(14)+k4cc) - d10*y(14)/(l10+y(14))-d0*y(14);
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
% =======================================================================