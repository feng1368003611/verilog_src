module uart_recv_tb();

	reg sys_clk;
	reg rst;


	reg [31:0] cnt;
	
	
	
	reg rxd;

	wire[7:0] out_dat;
	wire out_flag;

	
	initial begin
		sys_clk=0;
		rst=0;
		rxd=1;
		cnt=0;
	#3 	sys_clk=1;
	#4 	rst=1;
		repeat(800) begin
			#5 sys_clk=0;
			#5 sys_clk=1;
		end
		$stop;
	end
	
	
	
	always@( posedge sys_clk )begin
		
		if(!rst)begin
			cnt<=0;
		end
		else begin
			if(cnt<310) cnt<=cnt+1;
			else		cnt<=0;
			
			case(cnt)
			  1:begin  rxd<=1;  end
			  16:begin  rxd<=0;  end
			  
			  32:begin  rxd<=1;  end
			  48:begin  rxd<=0;  end
			  64:begin  rxd<=1;  end
			  80:begin  rxd<=0;  end
			  96:begin  rxd<=1;  end
			 112:begin  rxd<=0;  end
			 128:begin  rxd<=1;  end
			 144:begin  rxd<=0;  end
			  
			 160:begin  rxd<=1;  end
			 
			 169:begin  rxd<=0;  end
			 290:begin  rxd<=1;  end
			  
			endcase
			
		end
		
	end
	


uart_recv uart_recv_inst_0(

	. sys_clk(sys_clk) ,
	. rst(rst) ,
	
	. rxd(rxd) ,
	
	. out_dat(out_dat) ,
	. out_flag(out_flag) 
);
		  

endmodule
