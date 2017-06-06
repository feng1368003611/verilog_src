module sccb_controller(

	input sys_clk,
	input rst,
	
	input in_flag,
	
	input[7:0] in_dat,
	input[3:0] in_cmd,
	
	inout  sdl_wire,
	output reg scl,
	output reg sccb_e,
	
	output reg[7:0] out_dat,
	output reg out_flag,
	output reg busy
);

reg sdl;
assign sdl_wire=sdl;

parameter SCCB_STATE_IDLE	=4'b0000,
		  SCCB_CMD_START	=4'b0001,
		  SCCB_CMD_WRITE	=4'b0010,
		  SCCB_CMD_READ		=4'b0011,
		  SCCB_CMD_STOP		=4'b0110;

//to detect serial 1101
//          state  1234  ,idle state is 0

reg last_in_flag;
always@(posedge sys_clk or negedge rst) last_in_flag<= (!rst)?1:in_flag;
wire valid= (!last_in_flag)&&in_flag;



reg[7:0] dat_to_write;
always@(posedge in_flag or negedge rst) dat_to_write<= (!rst||busy)?0:in_dat;

reg[3:0] cmd;
always@(posedge in_flag or negedge rst) cmd<= (!rst||busy)?0:in_cmd;

reg[7:0] dat_to_send;

reg [15:0] current_state , next_state ;
reg[7:0] cnt;

always@(*) busy<=(!rst)?0:((cnt!=0) | valid );

always@(*)begin
	if(!rst)begin 
		next_state=SCCB_STATE_IDLE; scl=0; sdl=1'bz; dat_to_send=0; out_flag=0; sccb_e=1;
	end
	else 	begin 
		case(current_state)
		SCCB_STATE_IDLE:begin
			if(	valid ) begin	 next_state=cmd;		end
			scl=0; sdl=1'bz;
		end
		SCCB_CMD_START:begin
			if(cnt>=3)begin  next_state=SCCB_STATE_IDLE; end
			case(cnt)
			1:begin scl=0; sdl=1; sccb_e=1;end
			2:begin scl=1; sdl=1; sccb_e=1;end
			3:begin scl=1; sdl=1; sccb_e=0;end
			endcase
		end
		SCCB_CMD_WRITE:begin
			if(cnt>=18)begin next_state=SCCB_STATE_IDLE; end
			case(cnt)
			 1:begin scl=0; sdl=dat_to_write[7]; end
			 2:begin scl=1;  end
			 3:begin scl=0; sdl=dat_to_write[6]; end
			 4:begin scl=1;  end
			 5:begin scl=0; sdl=dat_to_write[5]; end
			 6:begin scl=1;  end
			 7:begin scl=0; sdl=dat_to_write[4]; end
			 8:begin scl=1;  end
			 9:begin scl=0; sdl=dat_to_write[3]; end
			10:begin scl=1;  end
			11:begin scl=0; sdl=dat_to_write[2]; end
			12:begin scl=1;  end
			13:begin scl=0; sdl=dat_to_write[1]; end
			14:begin scl=1;  end
			15:begin scl=0; sdl=dat_to_write[0]; end
			16:begin scl=1;  end
			17:begin scl=0; sdl=1'bz; end	// like I2C
			18:begin scl=1; sdl=1'bz; end
			endcase
		end
		SCCB_CMD_READ:begin
			if(cnt>=19)begin next_state=SCCB_STATE_IDLE; end
			case(cnt)
			 1:begin scl=0; sdl=1'bz; out_flag=0; end
			 2:begin scl=1; dat_to_send[7]=sdl;   end
			 3:begin scl=0;  end
			 4:begin scl=1; dat_to_send[6]=sdl; end
			 5:begin scl=0;   end
			 6:begin scl=1; dat_to_send[5]=sdl; end
			 7:begin scl=0;   end
			 8:begin scl=1; dat_to_send[4]=sdl; end
			 9:begin scl=0;   end
			10:begin scl=1; dat_to_send[3]=sdl; end
			11:begin scl=0;   end
			12:begin scl=1; dat_to_send[2]=sdl; end
			13:begin scl=0;   end
			14:begin scl=1; dat_to_send[1]=sdl; end
			15:begin scl=0;   end
			16:begin scl=1; out_dat={dat_to_send[7:1],sdl}; end
			17:begin scl=0; sdl=1'b1;  end
			18:begin scl=1; sdl=1'b1;  end // like I2C
			
			19:begin scl=1; out_flag=1;  end
			endcase
		end
		SCCB_CMD_STOP:begin
			if(cnt>=3)begin  next_state=SCCB_STATE_IDLE; end
			case(cnt)
			1:begin scl=0; sdl=1; sccb_e=0;	 end
			2:begin scl=1; sdl=1; sccb_e=0;	 end
			3:begin scl=1; sdl=1; sccb_e=1;	 end
			endcase
		end
		default:begin   	 next_state=SCCB_STATE_IDLE; end
		
		endcase
	end
end

always@(posedge sys_clk or negedge rst)begin

	if(!rst)begin  
		current_state<=0; cnt<=0; 
	end
	else begin
		
		current_state<=next_state;
		
		case(next_state)
		SCCB_STATE_IDLE:		begin cnt<=0;  end
		
		SCCB_CMD_START:		begin	if(cnt>=3)begin  cnt<=0;  end else begin cnt<=cnt+1'b1; end	end
		SCCB_CMD_WRITE:		begin	if(cnt>=18)begin cnt<=0;  end else begin cnt<=cnt+1'b1; end	end
		SCCB_CMD_READ:		begin	if(cnt>=19)begin cnt<=0;  end else begin cnt<=cnt+1'b1; end	end
		SCCB_CMD_STOP:		begin	if(cnt>=3)begin  cnt<=0;  end else begin cnt<=cnt+1'b1; end	end
		
		default:			begin cnt<=0;  end
		
		endcase
	end

end



endmodule
