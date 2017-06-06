module spi_controller_tb();

parameter SPI_STATE_IDLE  =4'b0000,
		  SPI_CMD_WRITE	  =4'b0010,
		  SPI_CMD_READ	  =4'b0011,
		  SPI_CMD_CS_0	  =4'b0100,
		  SPI_CMD_CS_1	  =4'b0101;

	reg sys_clk;
	reg rst;
	
	reg in_flag;
	
	reg[7:0] in_dat;
	reg[3:0] in_cmd;

	reg [31:0] cnt;
	
	wire si;
	
	wire so;
	
	wire cs;
	wire sck;
	
	wire[7:0] out_dat;
	wire out_flag;
	wire busy;
	
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
			  2:begin  in_flag<=0;  in_cmd<=SPI_CMD_CS_0;  end
			  3:begin  in_flag<=1;   end
			  
			  4:begin  in_flag<=0;  in_cmd<=SPI_CMD_WRITE; in_dat<=8'h91;  end
			  5:begin  in_flag<=1;   end
			  
			  6:begin  in_flag<=0;  in_cmd<=SPI_CMD_READ;  end
			  7:begin  in_flag<=1;   end
			  
			  8:begin  in_flag<=0;  in_cmd<=SPI_CMD_CS_1;  end
			  9:begin  in_flag<=1;   end

			endcase
			
		end
		
	end
	


spi_controller spi_controller_inst_0(

	. sys_clk(sys_clk) ,
	. rst(rst) ,
	
	. in_flag(in_flag) ,
	
	. in_dat(in_dat) ,
	. in_cmd(in_cmd) ,
	
	. so(so) ,
	
	. si(si) ,
	. sck(sck) ,
	. cs(cs) ,
	
	. out_dat(out_dat) ,
	. out_flag(out_flag) ,
	. busy(busy)
);

endmodule
