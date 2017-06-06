module initial_OV7670_tb();

parameter SPI_STATE_IDLE  =4'b0000,
		  SPI_CMD_WRITE	  =4'b0010,
		  SPI_CMD_READ	  =4'b0011,
		  SPI_CMD_CS_0	  =4'b0100,
		  SPI_CMD_CS_1	  =4'b0101;

	reg sys_clk;
	reg rst;
	
	reg in_flag;


	reg [31:0] cnt;
	

	
	
	initial begin
		sys_clk=0;
		rst=0;
		in_flag=0;
		in_dat=0;
		in_cmd=0;
		cnt=0;
	#3 	sys_clk=1;
	#4 	rst=1;
		repeat(200) begin
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
			if(!busy)cnt<=cnt+1;
			
			case(cnt)
			  2:begin  in_flag<=0;   end
			  3:begin  in_flag<=1;   end


			endcase
			
		end
		
	end
	


wire sccb_scl,sccb_sdl;
wire finish;
initial_OV7670 initial_OV7670_inst_0(
	. clk_in(sys_clk),
	. rst(rst),
	
	. in_flag(in_flag),
	
	. sccb_sdl(sccb_sdl),
	
	. sccb_scl(sccb_scl),
	. finish(finish)

);

endmodule
