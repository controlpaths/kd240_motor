`timescale 1ns/1ns

`define clkcycle 10
`define _1us 1000
`define _100us 100000
`define _1ms 1000000

module openloop_tb();

	reg aclk;
	reg resetn;

	wire [11:0] angle;
	wire signed [15:0] sin_signal;
	wire signed [15:0] cos_signal;

	wire signed [15:0] alpha_signal;
	wire signed [15:0] beta_signal;
	wire signed [15:0] a_signal;
	wire signed [15:0] b_signal;
	wire signed [15:0] c_signal;
	
	wire signed [15:0] a_signal_modulator;
	wire signed [15:0] b_signal_modulator;
	wire signed [15:0] c_signal_modulator;

	reg [15:0] d_vector;

	integer pwm_period;

	wire pwm_a;
	wire pwm_b;
	wire pwm_c;

	/* clock generation */
	initial begin
		aclk <= 1'b0;
		forever begin
			#(`clkcycle/2);
			aclk = ~aclk;
		end
	end

	/* module instantiation */
	angle_gen #(
	.angle_prescaler_width(12),
	.angle_width(12),
	.sincos_width(16)
	)dut_angle_gen(
	.aclk(aclk), 
	.resetn(resetn), 
	.angle_prescaler(1000), /* prescaler for angle increase */
	.angle(angle), /* output angle */
	.sin(sin_signal), /* sine */
	.cos(cos_signal) /* cosine */
	);	

	dq2abc #(
	.inout_width(16),
	.inout_decimal_width(15)
	)dut_dq2abd(
	.aclk(aclk), 
	.resetn(resetn),
	.d_vector(d_vector), /* direct vector */
	.q_vector(16'd0), /* quadrature vector */
	.sin(sin_signal), /* sine signal */
	.cos(cos_signal), /* cosine signal */
	.alpha(alpha_signal), /* direct signal */
	.beta(beta_signal), /* quadrature signal */
	.a(a_signal), /* modulator signals */
	.b(b_signal), /* modulator signals */
	.c(c_signal) /* modulator signals */
	);

	modulator_pwm_gain #(
	.inout_width(16),
	.inout_decimal_width(15),
	.pwm_period_width(16)
	) dut_modulator_pwm_gain (
	.aclk(aclk), 
	.resetn(resetn), 
	.pwm_period(pwm_period), /* pwm period */
	.mod_a(a_signal), /* modulator for phase a */
	.mod_b(b_signal), /* modulator for phase b */
	.mod_c(c_signal), /* modulator for phase c */
	.mod_a_gained(a_signal_modulator), /* modulator gained for phase a */
	.mod_b_gained(b_signal_modulator), /* modulator gained for phase b */
	.mod_c_gained(c_signal_modulator) /* modulator gained for phase c */
	);

	three_phase_modulator #(
	.pwm_period_width(16)
	) dut_three_phase_modulator (
	.aclk(aclk), 
	.resetn(resetn), 
	.pwm_period(pwm_period), /* pwm period */
	.mod_a(a_signal_modulator), /* modulator for phase a */
	.mod_b(b_signal_modulator), /* modulator for phase b */
	.mod_c(c_signal_modulator), /* modulator for phase c */
	.pwm_a(pwm_a), /* pwm output phase a */
	.pwm_b(pwm_b), /* pwm output phase b */
	.pwm_c(pwm_c) /* pwm output phase c */
	);

	/* test flow */
	initial begin
		$dumpfile("data_sim.vcd");
		$dumpvars();

		resetn <= 1'b0;

		pwm_period = 2500;
		d_vector = 0.5*2**15;

		#(5*`clkcycle);
		resetn <= 1'b1;

		#(50*`_1ms);
		$finish;
	end


endmodule