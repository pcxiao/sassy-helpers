
% Automatically converted model file: leloup03_b

function dydt = f(t, y, p)
   
% leloup03_b

eval(p);    
   
dydt = [   

	% Eqn:1 Mp
	(amp*force + 1) * vsP * ((y(14)^n_p) / ( (y(14)^n_p) + (KAP^n_p) )) - vmP * (y(1) / (y(1) + KmP)) - kdmp * y(1) ; 
	% Eqn:2 Mc
	vsC * ((y(14)^n_c) / ( (y(14)^n_c) + (KAC^n_c) )) - vmC * (y(2) / (y(2) + KmC)) - kdmc * y(2); 
	% Eqn:3 Mb
	vsB * ((KIB^m) / ( (KIB^m) + (y(19)^m) )) - vmB * (y(3) / (y(3) + KmB)) - kdmb * y(3); 
	% Eqn:4 Pc
	ksP * y(1) - V1P * (y(4) / (Kp_p + y(4))) + V2P * (y(6) / (Kdp_p + y(6))) + k4 * y(8) - k3 * y(4) * y(5) - kdn_p * y(4); 
	% Eqn:5 Cc
	ksC * y(2) - V1C * (y(5) / (Kp_c + y(5))) + V2C * (y(7) / (Kdp_c + y(7))) + k4 * y(8) - k3 * y(4) * y(5) - kdnc * y(5); 
	% Eqn:6 Pcp
	V1P * (y(4) /(y(4) + Kp_p) ) - V2P * (y(6) / (y(6) + Kdp_p)) - vdPC * (y(6) / (y(6) + Kd_p) ) - kdn_pp * y(6); 
	% Eqn:7 Ccp
	V1C * (y(5) /(y(5) + Kp_c) ) - V2C * (y(7) / (y(7) + Kdp_c)) - vdCC * (y(7) / (y(7) + Kd_c) ) - kdn_cp * y(7); 
	% Eqn:8 PCc
	- V1PC * (y(8) / (Kp_pcc + y(8))) + V2PC * (y(10) / (Kdp_pcc + y(10))) - k4 * y(8) + k3 * y(4) * y(5) + k2 * y(9) - k1 * y(8) - kdn_pcc * y(8); 
	% Eqn:9 PCn
	- V3PC * (y(9) / (Kp_pcn + y(9))) + V4PC * (y(11) / (Kdp_pcn + y(11))) - k2 * y(9) + k1 * y(8) - k7 * y(14) * y(9) + k8 * y(16) - kdn_pcn * y(9); 
	% Eqn:10 PCcp
	V1PC * (y(8) / (Kp_pcc + y(8))) - V2PC * (y(10) / (Kdp_pcc + y(10))) - vdPCC * (y(10) / (y(10) + Kd_pcc)) - kdn_pccp * y(10); 
	% Eqn:11 PCnp
	V3PC * (y(9) / (Kp_pcn + y(9))) - V4PC * (y(11) / (Kdp_pcn + y(11))) - vdPCN * (y(11) / (y(11) + Kd_pcn)) - kdn_pcnp * y(11); 
	% Eqn:12 Bc
	ksB * y(3) - V1B * (y(12) / (Kp_bc + y(12))) + V2B * (y(13) / (Kdp_bc + y(13))) - k5 * y(12) + k6 * y(14) - kdn_Bc * y(12); 
	% Eqn:13 Bcp
	V1B * (y(12) / (Kp_bc + y(12))) - V2B * (y(13) / (Kdp_bc + y(13))) - vdBC * (y(13) / (y(13) + Kd_bc)) - kdn_bcp * y(13); 
	% Eqn:14 Bn
	- V3B * (y(14) / (Kp_bn + y(14))) + V4B * (y(15) / (Kdp_bn + y(15))) + k5 * y(12) - k6 * y(14) - k7 * y(14) * y(9) + k8 * y(16) - kdn_bn * y(14); 
	% Eqn:15 Bnp
	V3B * (y(14) / (Kp_bn + y(14))) - V4B * (y(15) / (Kdp_bn + y(15))) - vdBN * (y(15) / (y(15) + Kd_bn)) - kdn_bnp * y(15); 
	% Eqn:16 In
	- k8 * y(16) + k7 * y(14) * y(9) - vdIN * ( y(16)/(y(16) + Kd_in) ) - kdn_in * y(16); 
	% Eqn:17 Mr
	vsR * ((y(14)^h) / ( (y(14)^h) + (KAR^h) )) - vmR * (y(17) / (y(17) + KmR)) - kdmr * y(17); 
	% Eqn:18 Rc
	ksR * y(17) - k9 * y(18) + k10 * y(19) - vdRC * (y(18) / (y(18) + Kd_rc) ) - kdn_rc * y(18); 
	% Eqn:19 Rn
	k9 * y(18) - k10 * y(19) - vdRN * (y(19) / (y(19) + Kd_rn)) - kdn_rn * y(19); 

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
%%%info leloup03_b
%%%method ode45
%%%orbit_type oscillator
% =======================================================================

