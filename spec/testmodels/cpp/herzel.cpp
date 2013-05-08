/**
 * @file herzel.cpp
 * 
 * Model implementation for Model 'herzel'
 *
 */

#include <cmath>

struct Model_herzel {
	Model_herzel() {
		reset_parameters();
	}

	void reset_parameters() {
		force = 0.0;
		dawn = 6.0;
		dusk = 18.0;
		d_x1 = 0.08;
		d_x2 = 0.06;
		d_x3 = 0.09;
		d_x5 = 0.17;
		d_x6 = 0.12;
		d_x7 = 0.15;
		d_y1 = 0.3;
		d_y2 = 0.2;
		d_y3 = 2.0;
		d_y4 = 0.2;
		d_y5 = 1.6;
		d_z1 = 0.23;
		d_z2 = 0.25;
		d_z3 = 0.6;
		d_z4 = 0.2;
		d_z5 = 0.2;
		d_z6 = 0.31;
		d_z7 = 0.3;
		d_z8 = 0.73;
		kf_x1 = 2.4;
		kd_x1 = 0.01;
		kf_z4 = 1.0;
		kd_z4 = 1.0;
		kf_z5 = 1.0;
		kd_z5 = 1.0;
		kph_z2 = 2.0;
		kd_phz3 = 0.05;
		V_1max = 1.0;
		V_2max = 2.92;
		V_3max = 1.9;
		V_4max = 10.9;
		V_5max = 1.0;
		k_t1 = 3.0;
		k_i1 = 0.9;
		k_t2 = 2.4;
		k_i2 = 0.7;
		k_i21 = 5.2;
		k_t3 = 2.07;
		k_i3 = 3.3;
		k_t4 = 0.9;
		k_i4 = 0.4;
		k_t5 = 8.35;
		k_i5 = 1.94;
		a = 12.0;
		d = 12.0;
		g = 5.0;
		h = 5.0;
		ii = 12.0;
		k_p1 = 0.4;
		k_p2 = 0.26;
		k_p3 = 0.37;
		k_p4 = 0.76;
		k_p5 = 1.21;
		ki_z4 = 0.2;
		ki_z5 = 0.1;
		ki_z6 = 0.5;
		ki_z7 = 0.1;
		ki_z8 = 0.1;
		ke_x2 = 0.02;
		ke_x3 = 0.02;
		b = 5.0;
		c = 7.0;
		e = 6.0;
		f = 4.0;
		f1 = 1.0;
		v = 6.0;
		w = 2.0;
		p = 6.0;
		q = 3.0;
		n = 2.0;
		m = 5.0;
		y1_0 = 0.0;
		y2_0 = 0.0;
		y3_0 = 0.0;
		y4_0 = 0.0;
		y5_0 = 0.0;
		transcription = 0.0;
		amp = 0.5;
	}

	void initial_state(double * y) {
		y[1] = 4.0;
		y[2] = 2.0;
		y[3] = 8.0;
		y[4] = 0.0;
		y[5] = 0.0;
		y[6] = 0.0;
		y[7] = 0.0;
		y[8] = 0.0;
		y[9] = 0.0;
		y[10] = 0.0;
		y[11] = 0.0;
		y[12] = 0.0;
		y[13] = 0.0;
		y[14] = 0.0;
		y[15] = 0.0;
		y[16] = 0.0;
		y[17] = 1.0;
		y[18] = 0.0;
		y[19] = 0.0;
	}

	// Herzel Mammalian Clock model equations 
// 
	double * operator() (double t, const double * y, double * dydt) {

		// y(1) == x1 -> CLOCK/BMAL  
		// Original: dydt[0] = kf_x1*y[9] - kd_x1*y[0] - d_x1*y[0]
		dydt[0] = kf_x1*y[9] - kd_x1*y[0] - d_x1*y[0] ;
		// y(2) == y3 -> Rev-Erb  
		// Original: dydt[1] = (1-transcription)*V_3max*((1 + g*(y[0]/k_t3)^v)/(1 +((y[17] + y[18])/k_i3)^w*(y[0]/k_t3)^v +(y[0]/k_t3)^v)) - d_y3*y[1]
		dydt[1] = (1-transcription)*V_3max*((1 + g*pow((y[0]/k_t3), v))/(1 +pow(((y[17] + y[18])/k_i3), w)*pow((y[0]/k_t3), v )+pow((y[0]/k_t3), v))) - d_y3*y[1] ;
		// y(3) == y4 -> ROR  
		// Original: dydt[2] = (1-transcription)*V_4max*((1 + h*(y[0]/k_t4)^p)/(1 +((y[17] + y[18])/k_i4)^q*(y[0]/k_t4)^p +(y[0]/k_t4)^p)) - d_y4*y[2]
		dydt[2] = (1-transcription)*V_4max*((1 + h*pow((y[0]/k_t4), p))/(1 +pow(((y[17] + y[18])/k_i4), q)*pow((y[0]/k_t4), p )+pow((y[0]/k_t4), p))) - d_y4*y[2] ;
		// y(4) == z6 -> REV-ERB-c  
		// Original: dydt[3] = k_p3*(y[1] + y3_0) - ki_z6*y[3] - d_z6*y[3]
		dydt[3] = k_p3*(y[1] + y3_0) - ki_z6*y[3] - d_z6*y[3] ;
		// y(5) == z7 -> ROR-c  
		// Original: dydt[4] = k_p4*(y[2] + y4_0) - ki_z7*y[4] - d_z7*y[4]
		dydt[4] = k_p4*(y[2] + y4_0) - ki_z7*y[4] - d_z7*y[4] ;
		// y(6) == x5 -> REV-ERB-n  
		// Original: dydt[5] = ki_z6*y[3] - d_x5*y[5]
		dydt[5] = ki_z6*y[3] - d_x5*y[5] ;
		// y(7) == x6 -> ROR-n  
		// Original: dydt[6] = ki_z7*y[4] - d_x6*y[6]
		dydt[6] = ki_z7*y[4] - d_x6*y[6] ;
		// y(8) == y5 -> BMAL  
		// Original: dydt[7] = (1-transcription)*V_5max*((1 + ii*(y[6]/k_t5)^n)/(1 +(y[5]/k_i5)^m +(y[6]/k_t5)^n)) - d_y5*y[7]
		dydt[7] = (1-transcription)*V_5max*((1 + ii*pow((y[6]/k_t5), n))/(1 +pow((y[5]/k_i5), m )+pow((y[6]/k_t5), n))) - d_y5*y[7] ;
		// y(9) == z8 -> BMAL-c  
		// Original: dydt[8] = k_p5*(y[7] + y5_0) - ki_z8*y[8] - d_z8*y[8]
		dydt[8] = k_p5*(y[7] + y5_0) - ki_z8*y[8] - d_z8*y[8] ;
		// y(10) == x7 -> BMAL-n  
		// Original: dydt[9] = ki_z8*y[8] + kd_x1*y[0] - kf_x1*y[9] - d_x7*y[9]
		dydt[9] = ki_z8*y[8] + kd_x1*y[0] - kf_x1*y[9] - d_x7*y[9] ;
		// y(11) == y1 -> Per  
		// Original: dydt[10] = (1-transcription)*(1+force*amp)*V_1max*((1 + a*(y[0]/k_t1)^b)/(1 +((y[17] + y[18])/k_i1)^c*(y[0]/k_t1)^b +(y[0]/k_t1)^b)) - d_y1*y[10]
		dydt[10] = (1-transcription)*(1+force*amp)*V_1max*((1 + a*pow((y[0]/k_t1), b))/(1 +pow(((y[17] + y[18])/k_i1), c)*pow((y[0]/k_t1), b )+pow((y[0]/k_t1), b))) - d_y1*y[10] ;
		// y(12) == y2 -> Cry  
		// Original: dydt[11] = (1-transcription)*V_2max*((1 + d*(y[0]/k_t2)^e)/(1 +((y[17] + y[18])/k_i2)^f*(y[0]/k_t2)^e +(y[0]/k_t2)^e))*1/(1 +(y[5]/k_i21)^f1) - d_y2*y[11]
		dydt[11] = (1-transcription)*V_2max*((1 + d*pow((y[0]/k_t2), e))/(1 +pow(((y[17] + y[18])/k_i2), f)*pow((y[0]/k_t2), e )+pow((y[0]/k_t2), e)))*1/(1 +pow((y[5]/k_i21), f1)) - d_y2*y[11] ;
		// y(13) == z1 -> CRY-c  
		// Original: dydt[12] = k_p2*(y[11] + y2_0) + kd_z4*y[15] + kd_z5*y[16] - kf_z5*y[12]*y[13] - kf_z4*y[12]*y[14] - d_z1*y[12]
		dydt[12] = k_p2*(y[11] + y2_0) + kd_z4*y[15] + kd_z5*y[16] - kf_z5*y[12]*y[13] - kf_z4*y[12]*y[14] - d_z1*y[12] ;
		// y(14) == z2 -> PER-c  
		// Original: dydt[13] = k_p1*(y[10] + y1_0) + kd_z5*y[16] + kd_phz3*y[14] - kf_z5*y[13]*y[12] - kph_z2*y[13] - d_z2*y[13]
		dydt[13] = k_p1*(y[10] + y1_0) + kd_z5*y[16] + kd_phz3*y[14] - kf_z5*y[13]*y[12] - kph_z2*y[13] - d_z2*y[13] ;
		// y(15) == z3 -> PER-c*  
		// Original: dydt[14] = kph_z2*y[13] + kd_z4*y[15] - kd_phz3*y[14] - kf_z4*y[14]*y[12] - d_z3*y[14]
		dydt[14] = kph_z2*y[13] + kd_z4*y[15] - kd_phz3*y[14] - kf_z4*y[14]*y[12] - d_z3*y[14] ;
		// y(16) == z4 -> PER-c*/CRY-c  
		// Original: dydt[15] = kf_z4*y[12]*y[14] + ke_x2*y[17] - ki_z4*y[15] - kd_z4*y[15] - d_z4*y[15]
		dydt[15] = kf_z4*y[12]*y[14] + ke_x2*y[17] - ki_z4*y[15] - kd_z4*y[15] - d_z4*y[15] ;
		// y(17) == z5 -> PER-c/CRY-c  
		// Original: dydt[16] = kf_z5*y[12]*y[13] + ke_x3*y[18] - ki_z5*y[16] - kd_z5*y[16] - d_z5*y[16]
		dydt[16] = kf_z5*y[12]*y[13] + ke_x3*y[18] - ki_z5*y[16] - kd_z5*y[16] - d_z5*y[16] ;
		// y(18) == x2 -> PER-n*/CRY-n  
		// Original: dydt[17] = ki_z4*y[15] - ke_x2*y[17] - d_x2*y[17]
		dydt[17] = ki_z4*y[15] - ke_x2*y[17] - d_x2*y[17] ;
		// y(19) == x3 -> PER-n/CRY-n  
		// Original: dydt[18] = ki_z5*y[16] - ke_x3*y[18] - d_x3*y[18]
		dydt[18] = ki_z5*y[16] - ke_x3*y[18] - d_x3*y[18] ;
		return dydt;
	}

	enum { NSPECIES = 20 };

	double force;
	double dawn;
	double dusk;
	double d_x1;
	double d_x2;
	double d_x3;
	double d_x5;
	double d_x6;
	double d_x7;
	double d_y1;
	double d_y2;
	double d_y3;
	double d_y4;
	double d_y5;
	double d_z1;
	double d_z2;
	double d_z3;
	double d_z4;
	double d_z5;
	double d_z6;
	double d_z7;
	double d_z8;
	double kf_x1;
	double kd_x1;
	double kf_z4;
	double kd_z4;
	double kf_z5;
	double kd_z5;
	double kph_z2;
	double kd_phz3;
	double V_1max;
	double V_2max;
	double V_3max;
	double V_4max;
	double V_5max;
	double k_t1;
	double k_i1;
	double k_t2;
	double k_i2;
	double k_i21;
	double k_t3;
	double k_i3;
	double k_t4;
	double k_i4;
	double k_t5;
	double k_i5;
	double a;
	double d;
	double g;
	double h;
	double ii;
	double k_p1;
	double k_p2;
	double k_p3;
	double k_p4;
	double k_p5;
	double ki_z4;
	double ki_z5;
	double ki_z6;
	double ki_z7;
	double ki_z8;
	double ke_x2;
	double ke_x3;
	double b;
	double c;
	double e;
	double f;
	double f1;
	double v;
	double w;
	double p;
	double q;
	double n;
	double m;
	double y1_0;
	double y2_0;
	double y3_0;
	double y4_0;
	double y5_0;
	double transcription;
	double amp;
};
