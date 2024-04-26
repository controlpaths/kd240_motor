/**
  Module name: dq2abc
  Author: P.Trujillo
  Date: April 2024
  Revision: 1.0
  History: 
    1.0: Module created
**/

`default_nettype none

module dq2abc #(
	parameter inout_width = 16,
	parameter inout_decimal_width = 15,
	parameter sqrt3_2 = 16'd28377
)(
	input wire aclk, 
	input wire resetn,

	input wire signed [inout_width-1:0] d_vector, /* direct vector */
	input wire signed [inout_width-1:0] q_vector, /* quadrature vector */

	input wire signed [inout_width-1:0] sin, /* sine signal */
	input wire signed [inout_width-1:0] cos, /* cosine signal */

	output wire signed [inout_width-1:0] alpha, /* direct signal */
	output wire signed [inout_width-1:0] beta, /* quadrature signal */

	output wire signed [inout_width-1:0] a, /* modulator signals */
	output wire signed [inout_width-1:0] b, /* modulator signals */
	output wire signed [inout_width-1:0] c /* modulator signals */
);

	// localparam sqrt3_2 = 0.8660254038 * 2**(inout_decimal_width); /* sqrt(3)/2 constant for alpha/beta to abc transformation*/

	wire signed [(inout_width*2)-1:0] d_cos_2width; /* d * cos */
	wire signed [(inout_width*2)-1:0] d_sin_2width; /* d * sin */
	wire signed [(inout_width*2)-1:0] q_cos_2width; /* q * cos */
	wire signed [(inout_width*2)-1:0] q_sin_2width; /* q * sin */

	wire signed [inout_width-1:0] d_cos; /* d * cos */
	wire signed [inout_width-1:0] d_sin; /* d * sin */
	wire signed [inout_width-1:0] q_cos; /* q * cos */
	wire signed [inout_width-1:0] q_sin; /* q * sin */
	
	wire signed [(inout_width*2)-1:0] beta_sqrt3_2_2width; /* beta*sqrt(3)/2 */
	wire signed [inout_width-1:0] beta_sqrt3_2; /* beta*sqrt(3)/2 */

	/**********************************************************************************
	*
	* DQ to alpha/beta
	*
	**********************************************************************************/

	assign d_cos_2width = d_vector * cos;
	assign d_sin_2width = d_vector * sin;
	assign q_cos_2width = q_vector * cos;
	assign q_sin_2width = q_vector * sin;

	assign d_cos = $signed(d_cos_2width >>> inout_decimal_width);
	assign d_sin = $signed(d_sin_2width >>> inout_decimal_width);
	assign q_cos = $signed(q_cos_2width >>> inout_decimal_width);
	assign q_sin = $signed(q_sin_2width >>> inout_decimal_width);

	assign alpha = d_cos - q_sin;
	assign beta = q_cos + d_sin;

	/**********************************************************************************
	*
	* alpha/beta to abc
	*
	**********************************************************************************/
	assign beta_sqrt3_2_2width = beta * sqrt3_2;

	assign beta_sqrt3_2 = $signed(beta_sqrt3_2_2width >>> inout_decimal_width);

	assign a = alpha;
	assign b = -$signed(alpha>>>1) + beta_sqrt3_2;
	assign c = -$signed(alpha>>>1) - beta_sqrt3_2;

endmodule