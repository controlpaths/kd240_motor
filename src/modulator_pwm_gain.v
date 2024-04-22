/**
  Module name: modulator_pwm_gain
  Author: P.Trujillo
  Date: April 2024
  Revision: 1.0
  History: 
    1.0: Module created
**/

`default_nettype none

module modulator_pwm_gain #(
	parameter inout_width = 16,
	parameter inout_decimal_width = 15,
	parameter pwm_period_width = 16
)(
	input wire aclk, 
	input wire resetn, 

	input wire signed [inout_width-1:0] pwm_period, /* pwm period */

	input wire signed [inout_width-1:0] mod_a, /* modulator for phase a */
	input wire signed [inout_width-1:0] mod_b, /* modulator for phase b */
	input wire signed [inout_width-1:0] mod_c, /* modulator for phase c */

	output wire signed [inout_width-1:0] mod_a_gained, /* modulator gained for phase a */
	output wire signed [inout_width-1:0] mod_b_gained, /* modulator gained for phase b */
	output wire signed [inout_width-1:0] mod_c_gained /* modulator gained for phase c */
);

	wire signed [(inout_width+pwm_period_width)-1:0] mod_a_gained_2width; /* modulator for phase a */
	wire signed [(inout_width+pwm_period_width)-1:0] mod_b_gained_2width; /* modulator for phase b */
	wire signed [(inout_width+pwm_period_width)-1:0] mod_c_gained_2width; /* modulator for phase c */

	/**********************************************************************************
	*
	* Multiplication by the pwm period
	*
	**********************************************************************************/
	assign mod_a_gained_2width = mod_a * pwm_period;
	assign mod_b_gained_2width = mod_b * pwm_period;
	assign mod_c_gained_2width = mod_c * pwm_period;

	assign mod_a_gained = $signed(mod_a_gained_2width >>> inout_decimal_width);
	assign mod_b_gained = $signed(mod_b_gained_2width >>> inout_decimal_width);
	assign mod_c_gained = $signed(mod_c_gained_2width >>> inout_decimal_width);

endmodule