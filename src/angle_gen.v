/**
  Module name: angle_gen
  Author: P.Trujillo
  Date: April 2024
  Revision: 1.0
  History: 
    1.0: Module created
**/

`default_nettype none

module angle_gen #(
	parameter angle_prescaler_width = 12,
	parameter angle_width = 12,
	parameter sincos_width = 16
)(
	input wire aclk, 
	input wire resetn, 

	input wire [angle_prescaler_width-1:0] angle_prescaler, /* prescaler for angle increase */

	output reg [angle_width-1:0] angle, /* output angle */
	output wire [sincos_width-1:0] sin, /* sine */
	output wire [sincos_width-1:0] cos /* cosine */
);	

	reg [angle_prescaler_width-1:0] prescaler_counter;

	reg signed [sincos_width-1:0] sine_signal [(2**angle_width)-1:0];
	reg signed [sincos_width-1:0] cosine_signal [(2**angle_width)-1:0];

	initial $readmemh("../memory_content/sin.mem", sine_signal);
	initial $readmemh("../memory_content/cos.mem", cosine_signal);

	always @(posedge aclk)
		if (!resetn) begin
			prescaler_counter <= 0;
			angle <= 0;
		end
		else 
			if (prescaler_counter < angle_prescaler)
				prescaler_counter <= prescaler_counter + 1;
			else begin
				prescaler_counter <= 0;
				angle <= angle + 1;
			end
	
	assign sin = sine_signal[angle];
	assign cos = cosine_signal[angle];
	
endmodule