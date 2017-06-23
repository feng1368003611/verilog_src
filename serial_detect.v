module serial_detect
#(
	parameter  LEN=4 ,
				STD=4'b1101
)(

	input sys_clk,
	input dat_in,
	
	input rst,
	
	output reg find

);

//to detect serial 1101
//          state  1123
reg[LEN-1:0] dat_middle;


reg[7:0] cnt;

always@(posedge sys_clk or negedge rst)begin
	if(!rst)begin
		dat_middle<=0; cnt<=0; find <= 0 ;
	end
	else begin
		
		if(dat_middle==STD & cnt>=LEN )begin cnt<=1; find <= 1 ; end
		else if(cnt<(LEN+2))begin cnt<=cnt+1; find <= 0 ; end
		else begin find <= 0 ; end
		dat_middle<= {dat_middle[LEN-1-1:0],dat_in};
		
	end
end


endmodule


