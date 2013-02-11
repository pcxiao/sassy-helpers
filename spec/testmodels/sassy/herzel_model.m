function dydt = f(t, y, p)
   
% Herzel Mammalian Clock model equations

eval(p);    
   
dydt = [  
    % y(1) == x1 -> CLOCK/BMAL 
    kf_x1*y(10) - kd_x1*y(1) - d_x1*y(1) ;
    
    % y(2) == y3 -> Rev-Erb 
    (1-transcription)*V_3max*( (1 + g* (y(1)/k_t3)^v )/(1 + ((y(18) + y(19))/k_i3)^w * (y(1)/k_t3)^v + (y(1)/k_t3)^v ) ) - d_y3*y(2)   ;
    
    % y(3) == y4 -> ROR 
    (1-transcription)*V_4max*( (1 + h* (y(1)/k_t4)^p )/(1 + ((y(18) + y(19))/k_i4)^q * (y(1)/k_t4)^p + (y(1)/k_t4)^p ) ) - d_y4*y(3)   ;
    
    % y(4) == z6 -> REV-ERB-c 
    k_p3*(y(2) + y3_0) - ki_z6*y(4) - d_z6*y(4)   ;

    % y(5) == z7 -> ROR-c
    k_p4*(y(3) + y4_0) - ki_z7*y(5) - d_z7*y(5)   ;

    % y(6) == x5 -> REV-ERB-n
    ki_z6*y(4) - d_x5*y(6)   ;

    % y(7) == x6 -> ROR-n
    ki_z7*y(5) - d_x6*y(7)   ;
    
    % y(8) == y5 -> BMAL
    (1-transcription)*V_5max*( (1 + ii*(y(7)/k_t5)^n ) / (1 + (y(6)/k_i5)^m + ( y(7)/k_t5 )^n ) ) - d_y5*y(8)   ;

    % y(9) == z8 -> BMAL-c
    k_p5*(y(8) + y5_0) - ki_z8*y(9) - d_z8*y(9)  ;

    % y(10) == x7 -> BMAL-n
    ki_z8*y(9) + kd_x1*y(1) - kf_x1*y(10) - d_x7*y(10) ;
    
    % y(11) == y1 -> Per
    (1-transcription)*(1+force*amp)*V_1max*( (1 + a* (y(1)/k_t1)^b )/(1 + ((y(18) + y(19))/k_i1)^c * (y(1)/k_t1)^b + (y(1)/k_t1)^b ) ) - d_y1*y(11)   ;

    % y(12) == y2 -> Cry
    (1-transcription)*V_2max*( (1 + d* (y(1)/k_t2)^e )/(1 + ((y(18) + y(19))/k_i2)^f * (y(1)/k_t2)^e + (y(1)/k_t2)^e ) ) * 1/(1 + (y(6)/k_i21)^f1 ) - d_y2*y(12)   ;

    % y(13) == z1 -> CRY-c
    k_p2*(y(12) + y2_0) + kd_z4*y(16) + kd_z5*y(17) - kf_z5*y(13)*y(14) - kf_z4*y(13)*y(15) - d_z1*y(13)   ;

    % y(14) == z2 -> PER-c
    k_p1*(y(11) + y1_0) + kd_z5*y(17) + kd_phz3*y(15) - kf_z5*y(14)*y(13) - kph_z2*y(14) - d_z2*y(14)  ;

    % y(15) == z3 -> PER-c*
    kph_z2*y(14) + kd_z4*y(16) - kd_phz3*y(15) - kf_z4*y(15)*y(13) - d_z3*y(15)   ;

    % y(16) == z4 -> PER-c*/CRY-c
    kf_z4*y(13)*y(15) + ke_x2*y(18) - ki_z4*y(16) - kd_z4*y(16) - d_z4*y(16)   ;

    % y(17) == z5 -> PER-c/CRY-c
    kf_z5*y(13)*y(14) + ke_x3*y(19) - ki_z5*y(17) - kd_z5*y(17) - d_z5*y(17)   ;

    % y(18) == x2 -> PER-n*/CRY-n
    ki_z4*y(16) - ke_x2*y(18) - d_x2*y(18)   ;

    % y(19) == x3 -> PER-n/CRY-n
    ki_z5*y(17) - ke_x3*y(19) - d_x3*y(19)   ;

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
%%%info Herzel Mammalian Clock model equations
%%%method ode45
%%%positivity non-negative
%%%orbit_type oscillator
% =======================================================================
