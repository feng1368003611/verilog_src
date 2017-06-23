

module count_1_tb();


reg in_rst_n;
reg [31:0] in_dat;


wire[5:0] out_1_cnt;


	reg[7:0] cnt;
	reg[8:0] pattern;
	reg sys_clk;
	
	initial begin
	
		in_rst_n=0;
		in_dat=0;
		sys_clk=0;
		
		cnt=0;
		pattern=4'b1011;
		
		#10 in_rst_n=1;
		
		repeat(100)begin 
			#5 sys_clk=1;
			#5 sys_clk=0;
		end
		$stop();
		
	end
	
always@(posedge sys_clk or negedge in_rst_n)begin
	if(!in_rst_n)begin
		cnt<=0; in_dat <=0;
	end
	else begin
		in_dat <=  in_dat+1; //pattern[cnt];//{$random()};//
		if(cnt==3)begin  cnt<=0; 	  end
		else 	   begin  cnt<=cnt+1;end
	end
end	



count_1  
#(
	. IN_LEN (32) ,
	. OUT_LEN(6) 

) count_1_inst_0 
(
	. in_dat(in_dat) ,
	. in_rst(in_rst_n) ,
	. out_1_cnt(out_1_cnt)
);

endmodule
