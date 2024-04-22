/**
  Module name: three_phase_modulator
  Author: P.Trujillo
  Date: April 2024
  Revision: 1.0
  History: 
    1.0: Module created
**/

`default_nettype none

module three_phase_modulator #(
	parameter pwm_period_width = 16
)(
	input wire aclk, 
	input wire resetn, 

	input wire signed [pwm_period_width-1:0] pwm_period, /* pwm period */
	input wire signed [pwm_period_width-1:0] mod_a, /* modulator for phase a */
	input wire signed [pwm_period_width-1:0] mod_b, /* modulator for phase b */
	input wire signed [pwm_period_width-1:0] mod_c, /* modulator for phase c */

	output reg pwm_a, /* pwm output phase a */
	output reg pwm_b, /* pwm output phase b */
	output reg pwm_c /* pwm output phase c */
);

	reg signed [pwm_period_width-1:0] carrier; /* period carrier */
	reg signed up; /* stores if the ramp is going up or down */

	/**********************************************************************************
	*
	* Carrier generation
	*
	**********************************************************************************/
	always @(posedge aclk)
		if (!resetn)
			up <= 1'b1;
		else
			if (up && (carrier >= pwm_period))
				up <= 1'b0;
			else if (!up && (carrier <= -pwm_period))
				up <= 1'b1;
			else 
				up <= up;
	
	always @(posedge aclk)
		if (!resetn)
			carrier <= 0;
		else 
			carrier <= up? carrier + 1: carrier - 1;

	/**********************************************************************************
	*
	* Phase comparators
	*
	**********************************************************************************/
	/* phase a comparator */
	always @(posedge aclk)
		if (!resetn)
			pwm_a <= 1'b0;
		else 
			pwm_a <= ($signed(mod_a > carrier))? 1'b1: 1'b0;

	/* phase b comparator */
	always @(posedge aclk)
		if (!resetn)
			pwm_b <= 1'b0;
		else 
			pwm_b <= ($signed(mod_b > carrier))? 1'b1: 1'b0;

	/* phase c comparator */
	always @(posedge aclk)
		if (!resetn)
			pwm_c <= 1'b0;
		else 
			pwm_c <= ($signed(mod_c > carrier))? 1'b1: 1'b0;

endmodule