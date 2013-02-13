% Automatically converted model file: leloup03

function dydt = f(t, y, p)
   
% leloup03_b

eval(p);    
   
dydt = [  
	% 1: MP; forced by light (Per mRNA) 
	% y(17) == BN
	(1-transcription)*(force*amp+vsP)*y(17)^n/(KAP^n+y(17)^n) - (vmP*y(1)/(KmP+y(1)) + kdmp*y(1));
	% 2: MC; (Cry mRNA)
	(1-transcription)*vsC*y(17)^n/(KAC^n+y(17)^n) - (vmC*y(2)/(KmC+y(2))+kdmc*y(2));
	% 3: MB; (BMAL mRNA)
	(1-transcription)*vsB*KIB^m/(KIB^m+y(12)^m) - (vmB*y(3)/(KmB+y(3))+kdmb*y(3));
	% 4: MR; (RevErb mRNA)
	(1-transcription)*vsR*y(17)^h/(KAR^h + y(17)^h) - (vmR*y(4)/(KmR+y(4))+kdmr*y(4));
	
	% 5: PC; (Per in Cytosol)
	ksP*y(1) + V2P*y(8)/(Kdp+y(8)) + k4*y(10) - (V1P*y(5)/(Kp+y(5)) + k3*y(5)*y(6) + kdn*y(5) );
	% 6: CC; (Cry in Cytosol)
	ksC*y(2) + V2C*y(9)/(Kdp+y(9)) + k4*y(10) - (V1C*y(6)/(Kp+y(6)) + k3*y(5)*y(6) + kdnc*y(6));
	% 7: RC; (RevErb in Cytosol)
	ksR*y(4) + k10*y(12) - (k9*y(7) + vdRC*y(7)/(Kd+y(7)) + kdn*y(7));
	
	% 8: PCP; (Phosphorylated Per in Cytosol)
	V1P*y(5)/(Kp+y(5)) - (V2P*y(8)/(Kdp+y(8)) + vdPC*y(8)/(Kd+y(8)) + kdn*y(8));
	% 9: CCP; (Phosphorylated Cry in Cytosol)
	V1C*y(6)/(Kp+y(6)) - (V2C*y(9)/(Kdp+y(9)) + vdCC*y(9)/(Kd+y(9)) + kdn*y(9));

	% 10: PCC; (Per-Cry Complex in Cytosol)
	V2PC*y(13)/(Kdp+y(13)) + k3*y(5)*y(6) + k2*y(11) - (V1PC*y(10)/(Kp+y(10)) + k4*y(10) + k1*y(10) + kdn*y(10));	
	% 11: PCN; (Per-Cry Complex in Nucleus)
	V4PC*y(14)/(Kdp+y(14)) + k1*y(10) + k8*y(19) - (V3PC*y(11)/(Kp+y(11)) + k2*y(11) + k7*y(17)*y(11) + kdn*y(11));
	
	% 12: RN; (nucl. RevErb)
	k9*y(7) - (k10*y(12) + vdRN*y(12)/(Kd+y(12)) + kdn*y(12));
	
	% 13: PCCP; (Phosphorylated Per-Cry Complex in Cytosol)
	V1PC*y(10)/(Kp+y(10)) - (V2PC*y(13)/(Kdp+y(13)) + vdPCC*y(13)/(Kd+y(13)) + kdn*y(13));
	% 14: PCNP; (Phosphorylated Per-Cry Complex in Nucleus)
	V3PC*y(11)/(Kp+y(11)) - (V4PC*y(14)/(Kdp+y(14)) + vdPCN*y(14)/(Kd+y(14)) + kdn*y(14));
	
	% 15: BC; (BMAL in Cytosol)
	V2B*y(16)/(Kdp+y(16)) + k6*y(17) + ksB*y(3) - (V1B*y(15)/(Kp+y(15)) + k5*y(15) + kdn*y(15));
	% 16: BCP; (Phosphorylated BMAL in Cytosol)
	V1B*y(15)/(Kp+y(15)) - (V2B*y(16)/(Kdp+y(16)) + vdBC*y(16)/(Kd+y(16)) + kdn*y(16));
	
	% 17: BN; (BMAL in Nucleus)
	V4B*y(18)/(Kdp+y(18)) + k5*y(15) + k8*y(19) - (V3B*y(17)/(Kp+y(17)) + k6*y(17) + k7*y(17)*y(11) + kdn*y(17));
	% 18: BNP; (Phosphorylated BMAL in Nucleus)
	V3B*y(17)/(Kp+y(17)) - (V4B*y(18)/(Kdp+y(18)) + vdBN*y(18)/(Kd+y(18)) + kdn*y(18));
	% 19: IN; (Inactive Complex Per-Cry and Clock-BMAL in Nucleus)
	k7*y(17)*y(11) - (k8*y(19) + vdIN*y(19)/(Kd+y(19)) + kdn*y(19));

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
%%%positivity non-negative
%%%orbit_type oscillator
% =======================================================================
