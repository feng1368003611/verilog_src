module serial_detect(

	input sys_clk,
	input dat_in,
	
	input rst,
	
	output reg find

);

//to detect serial 1101
//          state  1123
reg[3:0] dat_middle;
parameter STD=4'b1101;

reg[7:0] cnt;

always@(posedge sys_clk or negedge rst)begin
	if(!rst)begin
		dat_middle<=0; cnt<=0;
	end
	else begin
		
		if(dat_middle==STD)begin cnt<=1; end
		else if(cnt<6)begin cnt<=cnt+1;  end
		
		dat_middle<= {dat_middle[2:0],dat_in};
		
	end
end

always@(*)begin
	if(!rst)begin
		find = 0 ;
	end
	else begin
		find = (dat_middle==STD) && cnt>=4 ;
	end
end

endmodule


