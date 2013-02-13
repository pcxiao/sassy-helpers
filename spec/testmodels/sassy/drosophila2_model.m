function dydt = f(t, y, p)

% interlocked feedback loops drosophila (Boris)

eval(p); 

dydt = [  
    
  % *********** L1 ************

  % per mRNA 
    alpha1 * (k07 * y(8)^npow/(k07h^npow+y(8)^npow)-k0d * y(1) / (y(1) + k0dh) - kd * y(1));
 % tim mRNA 
    alpha1 * (k17 * y(8)^npow/(k17h^npow+y(8)^npow)-k1d * y(2) / (y(2) + k1dh) - kd * y(2));
    
  % per protein
    alpha1 * (k2 * y(1) - k23 * y(3) * y(4)+k4 * y(5)-kd * y(3)-k2d * y(3) /(y(3) + k2dh));
    
  % tim protein 
    alpha1 * (k3 * y(2) - k23 * y(4) * y(3)+k4 * y(5)-kd * y(4)-(k3d + amp * force) * y(4) /(y(4) + k3dh));
    
    
  % per-tim dimer 
    alpha1 * (k23 * y(3) * y(4)-k4 * y(5)-kd * y(5)-k74 * y(8) * y(5) + k8 * y(9));
   

  % *********** L2 ************


  % clock mRNA 
    alpha1 * (k57 * k5^npow/(k5^npow + y(8)^npow)-k5d * y(6) /(y(6) + k5dh));
 
    
  % clock protein 
    alpha1 * (k6 * y(6) - kcc * y(7) + k7 * y(8)-(k6d + 0 * force) * y(7) /(y(7) + k6dh));
    
 
  % clock-cycle dimer 
    alpha1 * (kcc * y(7) - k7 * y(8) - kd * y(8)-k74 * y(8) * y(5) + k8 * y(9));
  
  
  % clock-time - per-tim non-active complex 
    alpha1 * (k74 * y(8) * y(5)-k8 * y(9)-k8d * y(9) / (y(9) + k8dh));
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
%%%info interlocked feedback loops drosophila (Boris)
% =======================================================================
