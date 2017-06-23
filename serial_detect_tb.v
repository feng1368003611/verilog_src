module serial_detect_tb();


	reg sys_clk;
	reg dat_in;
	
	reg rst;
	
	wire  find;

	reg[7:0] cnt;
	reg[8:0] pattern;
	
	initial begin
	
		rst=0;
		dat_in=0;
		sys_clk=0;
		
		cnt=0;
		pattern=4'b1011;
		
		#10 rst=1;
		
		repeat(100)begin 
			#5 sys_clk=1;
			#5 sys_clk=0;
		end
		$stop();
		
	end
	
always@(posedge sys_clk or negedge rst)begin
	if(!rst)begin
		cnt<=0; dat_in <=0;
	end
	else begin
		dat_in <=  pattern[cnt];//{$random()};//
		if(cnt==3)begin  cnt<=0; 	  end
		else 	   begin  cnt<=cnt+1;end
	end
end	
	
	
	serial_detect 
	#( .LEN(5), .STD(5'b01110)) 
	serial_detect_inst_0(

	. sys_clk(sys_clk) ,
	. dat_in(dat_in) ,
	
	. rst(rst) ,
	
	.  find(find)
	);
	



endmodule


