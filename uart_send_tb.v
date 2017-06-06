module uart_send_tb();

	reg sys_clk;
	reg rst;


	reg [31:0] cnt;
	
	
	
	wire txd;
	wire busy;
	
	reg[7:0] in_dat;
	reg in_flag;

	
	initial begin
		sys_clk=0;
		rst=0;
		cnt=0;
	#3 	sys_clk=1;
	#4 	rst=1;
		repeat(800) begin
			#5 sys_clk=0;
			#5 sys_clk=1;
		end
		$stop;
	end
	
	
	
	always@( posedge sys_clk or negedge rst)begin
		
		if(!rst)begin
			cnt<=0;
		end
		else begin
			if(!busy) cnt<=cnt+1;
			
			case(cnt)
			  1:begin  in_flag<=0; in_dat<=8'h55; end
			  2:begin  in_flag<=1;  end
			  
			  3:begin  in_flag<=0; in_dat<=8'h82; end
			  4:begin  in_flag<=1;  end
			  
			endcase
			
		end
		
	end
	


uart_send uart_send_inst_0(

	. sys_clk(sys_clk),
	. rst(rst),
	
	. in_dat(in_dat),
	. in_flag(in_flag)	,
	
	. txd(txd),
	. busy(busy)
);		  

endmodule
