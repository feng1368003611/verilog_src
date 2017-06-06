



module lpf(
	input clk,
	input rst,
	
	input [7:0] in_dat,
	
	output reg [7:0] out_dat
	
);

reg [63:0] buf_dat;
parameter factor0=1,
		  factor1=1,
		  factor2=1,
		  factor3=1,
		  factor4=1,
		  factor5=1,
		  factor6=1,
		  factor7=1;
parameter aveg=factor0+factor1+factor2+factor3+factor4+factor5+factor6+factor7;

always@(*)begin

	if(!rst)begin
		out_dat<=0;
	end
	else begin
		out_dat<=(
				 buf_dat[63:56]*factor0
				+buf_dat[55:48]*factor1
				+buf_dat[47:40]*factor2
				+buf_dat[39:32]*factor3
				+buf_dat[31:24]*factor4
				+buf_dat[23:16]*factor5
				+buf_dat[15:8 ]*factor6
				+buf_dat[7 :0 ]*factor7
				)/aveg;
	end
	
end

always@(posedge clk or negedge rst)begin

	if(!rst)begin
		buf_dat<=0;
	end
	else begin
		buf_dat<={  buf_dat[55:0],in_dat  };
	end
	
end


endmodule

