module serial_detect(

	input [31:0]data,
	
	output  [31:0]crc_out,

);

parameter LEN=5-1;
parameter TOTAL_LEN=32-1;
parameter GX=(LEN+1)'b10011

assign crc_out = genCRC(  data , LEN );



function [TOTAL_LEN:0]genCRC;

input [TOTAL_LEN:0] mx;
reg [TOTAL_LEN:0] backup;
reg [7:0]i=TOTAL_LEN;

begin
	mx=mx<<LEN;
	backup = mx;
	while(i>=LEN)begin
		if(mx[i])begin mx = mx^(  GX<<(i-LEN) );end
		//or do a or action &mx[i]
		i  = i-1;
	end
	genCRC = mx | backup;
end

endfunction




endmodule


