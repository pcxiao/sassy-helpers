# -*- encoding: utf-8 -*-
require "treetop"
require "sassy-helpers"
require 'tempfile'

describe Modelling::SassyModel do
	it 'loads sassy models' do 
		m = Modelling::Model.new
		m.from_sassy('spec/testmodels/sassy/herzel')
	end

	it 'writes sassy models' do
		file1 = Tempfile.new('model_tmp')
		p = file1.path
		file1.close
		file1.unlink   # deletes the temp file

		begin
			m = Modelling::Model.new
			m.from_sassy('spec/testmodels/sassy/herzel')

			m.to_sassy(p)

			modeltext = File.read(p + "_model.m")
			modeltext.should eql( "function dydt = f(t, y, p)\n   \n% Herzel Mammalian Clock model equations  \n\neval(p);\n\ndydt = [  \n     % y(1) == x1 -> CLOCK/BMAL  \n     kf_x1*y(10) - kd_x1*y(1) - d_x1*y(1) ;\n     % y(2) == y3 -> Rev-Erb  \n     (1-transcription)*V_3max*((1 + g*(y(1)/k_t3)^v)/(1 + ((y(18) + y(19))/k_i3)^w*(y(1)/k_t3)^v + (y(1)/k_t3)^v)) - d_y3*y(2) ;\n     % y(3) == y4 -> ROR  \n     (1-transcription)*V_4max*((1 + h*(y(1)/k_t4)^p)/(1 + ((y(18) + y(19))/k_i4)^q*(y(1)/k_t4)^p + (y(1)/k_t4)^p)) - d_y4*y(3) ;\n     % y(4) == z6 -> REV-ERB-c  \n     k_p3*(y(2) + y3_0) - ki_z6*y(4) - d_z6*y(4) ;\n     % y(5) == z7 -> ROR-c  \n     k_p4*(y(3) + y4_0) - ki_z7*y(5) - d_z7*y(5) ;\n     % y(6) == x5 -> REV-ERB-n  \n     ki_z6*y(4) - d_x5*y(6) ;\n     % y(7) == x6 -> ROR-n  \n     ki_z7*y(5) - d_x6*y(7) ;\n     % y(8) == y5 -> BMAL  \n     (1-transcription)*V_5max*((1 + ii*(y(7)/k_t5)^n)/(1 + (y(6)/k_i5)^m + (y(7)/k_t5)^n)) - d_y5*y(8) ;\n     % y(9) == z8 -> BMAL-c  \n     k_p5*(y(8) + y5_0) - ki_z8*y(9) - d_z8*y(9) ;\n     % y(10) == x7 -> BMAL-n  \n     ki_z8*y(9) + kd_x1*y(1) - kf_x1*y(10) - d_x7*y(10) ;\n     % y(11) == y1 -> Per  \n     (1-transcription)*(1+force*amp)*V_1max*((1 + a*(y(1)/k_t1)^b)/(1 + ((y(18) + y(19))/k_i1)^c*(y(1)/k_t1)^b + (y(1)/k_t1)^b)) - d_y1*y(11) ;\n     % y(12) == y2 -> Cry  \n     (1-transcription)*V_2max*((1 + d*(y(1)/k_t2)^e)/(1 + ((y(18) + y(19))/k_i2)^f*(y(1)/k_t2)^e + (y(1)/k_t2)^e))*1/(1 + (y(6)/k_i21)^f1) - d_y2*y(12) ;\n     % y(13) == z1 -> CRY-c  \n     k_p2*(y(12) + y2_0) + kd_z4*y(16) + kd_z5*y(17) - kf_z5*y(13)*y(14) - kf_z4*y(13)*y(15) - d_z1*y(13) ;\n     % y(14) == z2 -> PER-c  \n     k_p1*(y(11) + y1_0) + kd_z5*y(17) + kd_phz3*y(15) - kf_z5*y(14)*y(13) - kph_z2*y(14) - d_z2*y(14) ;\n     % y(15) == z3 -> PER-c*  \n     kph_z2*y(14) + kd_z4*y(16) - kd_phz3*y(15) - kf_z4*y(15)*y(13) - d_z3*y(15) ;\n     % y(16) == z4 -> PER-c*/CRY-c  \n     kf_z4*y(13)*y(15) + ke_x2*y(18) - ki_z4*y(16) - kd_z4*y(16) - d_z4*y(16) ;\n     % y(17) == z5 -> PER-c/CRY-c  \n     kf_z5*y(13)*y(14) + ke_x3*y(19) - ki_z5*y(17) - kd_z5*y(17) - d_z5*y(17) ;\n     % y(18) == x2 -> PER-n*/CRY-n  \n     ki_z4*y(16) - ke_x2*y(18) - d_x2*y(18) ;\n     % y(19) == x3 -> PER-n/CRY-n  \n     ki_z5*y(17) - ke_x3*y(19) - d_x3*y(19) ;\n]; \n\n% ======================================================================= \n% the information below is written into the file name.info and is used to \n% communicate whether the system is an oscillator or a signalling system, \n% which ode solver method to use, the end time is teh system is a signal, \n% the force type used from the file /shared/theforce and wherther the \n% solutions should be non-negative or not. The %%%  before \n% each line is needed. Using %%% info lines it can also be used to store away \n% other information. In this case the title of the model and the initial \n% condition that is used. \n%%% info Herzel Mammalian Clock model equations \n%%% method ode45 \n%%% positivity non-negative \n%%% orbit_type oscillator \n% ======================================================================= \n\nend\n")
			parameters = File.read(p + ".par")
			parameters.should eql( "force    0.0   \"set to 1 to enable per induction\"\nd_x1    0.08   \"deg. CLOCK/BMAL\"\nd_x2    0.06   \"deg. PER_n*/CRY_n\"\nd_x3    0.09   \"deg. PER_n/CRY_n\"\nd_x5    0.17   \"deg. REV-ERB_n\"\nd_x6    0.12   \"deg. ROR_n\"\nd_x7    0.15   \"deg. BMAL_n\"\nd_y1    0.3   \"deg. Per mRNA\"\nd_y2    0.2   \"deg. Cry mRNA\"\nd_y3    2.0   \"deg. Rev-Erb mRNA\"\nd_y4    0.2   \"deg. Ror mRNA\"\nd_y5    1.6   \"deg. Bmal mRNA\"\nd_z1    0.23   \"deg. CRY_c\"\nd_z2    0.25   \"deg. PER_c\"\nd_z3    0.6   \"deg. PER_c*\"\nd_z4    0.2   \"deg. PER_c*/CRY_c\"\nd_z5    0.2   \"deg. PER_c/CRY_c\"\nd_z6    0.31   \"deg. REV-ERB_c\"\nd_z7    0.3   \"deg. ROR_c\"\nd_z8    0.73   \"deg. BMAL_c\"\nkf_x1    2.4   \"CLOCK/BMAL-complex formation rate 1/h\"\nkd_x1    0.01   \"CLOCK/BMAL-complex dissociation rate 1/h\"\nkf_z4    1.0   \"PER_c*/CRY_c-complex formation rate (a.u.*h)^-1\"\nkd_z4    1.0   \"PER_c*/CRY_c-complex dissociation rate (h)^-1\"\nkf_z5    1.0   \"PER_c/CRY_c-complex formation rate (a.u.*h)^-1\"\nkd_z5    1.0   \"PER_c/CRY_c-complex dissociation rate (h)^-1\"\nkph_z2    2.0   \"PER_c phosphorylation rate\"\nkd_phz3    0.05   \"PER_c phosphorylation rate\"\nV_1max    1.0   \"transc. rate Per\"\nV_2max    2.92   \"transc. rate Cry\"\nV_3max    1.9   \"transc. rate Rev-Erb\"\nV_4max    10.9   \"transc. rate Ror\"\nV_5max    1.0   \"transc. rate Bmal\"\nk_t1    3.0   \"Per-activation rate\"\nk_i1    0.9   \"Per-inhibition rate\"\nk_t2    2.4   \"Cry-activation rate\"\nk_i2    0.7   \"Cry-inhibition rate\"\nk_i21    5.2   \"Cry-inhibition rate\"\nk_t3    2.07   \"Rev-Erb-activation rate\"\nk_i3    3.3   \"Rev-Erb-inhibition rate\"\nk_t4    0.9   \"Ror-activation rate\"\nk_i4    0.4   \"Ror-inhibition rate\"\nk_t5    8.35   \"Bmal-activation rate\"\nk_i5    1.94   \"Bmal-inhibition rate\"\na    12.0   \"Per fold activation\"\nd    12.0   \"Cry fold activation\"\ng    5.0   \"Rev-Erb fold activation\"\nh    5.0   \"Ror fold activation\"\nii    12.0   \"Bmal fold activation\"\nk_p1    0.4   \"PER_c production rate\"\nk_p2    0.26   \"CRY_c production rate\"\nk_p3    0.37   \"REV-ERB_c production rate\"\nk_p4    0.76   \"ROR_c production rate\"\nk_p5    1.21   \"BMAL_c production rate\"\nki_z4    0.2   \"PER_c*/CRY_c import rate\"\nki_z5    0.1   \"PER_c/CRY_c import rate\"\nki_z6    0.5   \"REV-ERB_c import rate\"\nki_z7    0.1   \"ROR_c import rate\"\nki_z8    0.1   \"BMAL_c import rate\"\nke_x2    0.02   \"PER_n*/CRY_n export rate\"\nke_x3    0.02   \"PER_n/CRY_n export rate\"\nb    5.0   \"Per activation\"\nc    7.0   \"Per inhibition\"\ne    6.0   \"Cry activation\"\nf    4.0   \"Cry inhibition\"\nf1    1.0   \"Cry-inhibition\"\nv    6.0   \"Rev-Erb activation\"\nw    2.0   \"Rev-Erb inhibition\"\np    6.0   \"Ror activation\"\nq    3.0   \"Ror inhibition\"\nn    2.0   \"Bmal activation\"\nm    5.0   \"Bmal inhibition\"\ny1_0    0.0   \"Per\"\ny2_0    0.0   \"Cry\"\ny3_0    0.0   \"Rev-Erb\"\ny4_0    0.0   \"Ror\"\ny5_0    0.0   \"Bmal\"\ntranscription    0.0   \"Transcription off switch (0 -> transc. on, 1-> off)\"\namp    0.5   \"light input amplification\"\ndawn    6.0   \"external force on\"\ndusk    18.0   \"external force off\"\n")
			initials = File.read(p + ".y")
			initials.should eql( "y1 4.0\ny2 2.0\ny3 8.0\ny4 0.0\ny5 0.0\ny6 0.0\ny7 0.0\ny8 0.0\ny9 0.0\ny10 0.0\ny11 0.0\ny12 0.0\ny13 0.0\ny14 0.0\ny15 0.0\ny16 0.0\ny17 1.0\ny18 0.0\ny19 0.0\n")
		ensure
			if File.exists?(p + "_model.m")
				File.unlink (p + "_model.m")
			end
			if File.exists?(p + ".par")
				File.unlink (p + ".par")
			end
			if File.exists?(p + ".y")
				File.unlink (p + ".y")
			end
		end
	end

end