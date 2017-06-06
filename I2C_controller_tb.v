module I2C_controller_tb();

parameter I2C_STATE_IDLE  =4'b0000,
		  I2C_CMD_START	  =4'b0001,
		  I2C_CMD_WRITE	  =4'b0010,
		  I2C_CMD_READ	  =4'b0011,
		  I2C_CMD_RECV_ACK=4'b0100,
		  I2C_CMD_SEND_ACK=4'b0101,
		  I2C_CMD_STOP	  =4'b0110,
		  I2C_CMD_SEND_NACK=4'b0111;

	reg sys_clk;
	reg rst;
	
	reg in_flag;
	
	reg[7:0] in_dat;
	reg[3:0] in_cmd;

	reg [31:0] cnt;
	
	
	wire sdl;
	wire scl;
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
		repeat(2000) begin
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
			  2:begin  in_flag<=0;  in_cmd<=I2C_CMD_START;  end
			  3:begin  in_flag<=1;   end
			  
			  4:begin  in_flag<=0;  in_cmd<=I2C_CMD_WRITE; in_dat<=8'h91;  end
			  5:begin  in_flag<=1;   end
			  
			  6:begin  in_flag<=0;  in_cmd<=I2C_CMD_RECV_ACK;  end
			  7:begin  in_flag<=1;   end
			  
			  8:begin  in_flag<=0;  in_cmd<=I2C_CMD_READ;  end
			  9:begin  in_flag<=1;   end
			  
			  10:begin  in_flag<=0;  in_cmd<=I2C_CMD_SEND_ACK;  end
			  11:begin  in_flag<=1;   end
			  
			  12:begin  in_flag<=0;  in_cmd<=I2C_CMD_READ;  end
			  13:begin  in_flag<=1;   end
			  
			  14:begin  in_flag<=0;  in_cmd<=I2C_CMD_SEND_NACK;  end
			  15:begin  in_flag<=1;   end  
			  
			  16:begin  in_flag<=0;  in_cmd<=I2C_CMD_STOP;  end
			  17:begin  in_flag<=1;   end
			  
			endcase
			
		end
		
	end
	


I2C_controller I2C_controller_inst_0(

	. sys_clk(sys_clk) ,
	. rst(rst) ,
	
	. in_flag(in_flag) ,
	
	. in_dat(in_dat) ,
	. in_cmd(in_cmd) ,
	
	. sdl_wire(sdl) ,
	. scl(scl) ,
	
	. out_dat(out_dat) ,
	. out_flag(out_flag) ,
	. busy(busy)
);		  
		  

endmodule
