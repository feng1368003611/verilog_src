module spi_controller(

	input sys_clk,
	input rst,
	
	input in_flag,
	
	input[7:0] in_dat,
	input[3:0] in_cmd,
	
	input 	   so,
	output reg si,
	output reg sck,
	output reg cs,
	
	output reg[7:0] out_dat,
	output reg out_flag,
	output reg busy
);


parameter SPI_STATE_IDLE  =4'b0000,
		  SPI_CMD_WRITE	  =4'b0010,
		  SPI_CMD_READ	  =4'b0011,
		  SPI_CMD_CS_0	  =4'b0100,
		  SPI_CMD_CS_1	  =4'b0101;



reg last_in_flag;
always@(posedge sys_clk or negedge rst)begin
	if(!rst) begin  last_in_flag<=1; 	 end
	else 	 begin  last_in_flag<=in_flag; end
end

wire valid= (!last_in_flag)&&in_flag;

reg[3:0] cmd;
always@( posedge in_flag or negedge rst  )begin
	if(!rst) begin  cmd<=0; 	 end
	else 	 begin  cmd<=in_cmd; end
end

reg[7:0] dat_to_write;
always@(posedge in_flag or negedge rst)begin
	if(!rst) begin  dat_to_write<=0; 	 end
	else 	 begin  dat_to_write<=in_dat; end
end




reg[7:0] dat_to_send;

reg [15:0] current_state , next_state ;
reg[7:0] cnt;

always@(*) busy<=(!rst)?0:((cnt!=0) | valid );

always@(*)begin
	if(!rst)begin 
		next_state=SPI_STATE_IDLE; si=0; sck=0; cs=1;   dat_to_send=0; out_flag=0;
	end
	else 	begin
		case(current_state)
		SPI_STATE_IDLE:begin
			if(valid) begin
				case(cmd)
				SPI_CMD_WRITE:begin next_state=SPI_CMD_WRITE; end
				SPI_CMD_READ :begin next_state=SPI_CMD_READ ; end
				SPI_CMD_CS_0 :begin next_state=SPI_CMD_CS_0 ; end
				SPI_CMD_CS_1 :begin next_state=SPI_CMD_CS_1 ; end
				endcase
			end
			else begin
				next_state=SPI_STATE_IDLE;
			end
			si=0; sck=0;  out_flag=0;
		end
		SPI_CMD_WRITE:begin
			if(cnt>=16)begin next_state=SPI_STATE_IDLE; end
			else	   begin next_state=SPI_CMD_WRITE ; end
			
			case(cnt)
			 1:begin cs=0; sck=0; si=dat_to_write[7]; end
			 2:begin cs=0; sck=1; si=dat_to_write[7]; end
			 3:begin cs=0; sck=0; si=dat_to_write[6]; end
			 4:begin cs=0; sck=1; si=dat_to_write[6]; end
			 5:begin cs=0; sck=0; si=dat_to_write[5]; end
			 6:begin cs=0; sck=1; si=dat_to_write[5]; end
			 7:begin cs=0; sck=0; si=dat_to_write[4]; end
			 8:begin cs=0; sck=1; si=dat_to_write[4]; end
			 9:begin cs=0; sck=0; si=dat_to_write[3]; end
			10:begin cs=0; sck=1; si=dat_to_write[3]; end
			11:begin cs=0; sck=0; si=dat_to_write[2]; end
			12:begin cs=0; sck=1; si=dat_to_write[2]; end
			13:begin cs=0; sck=0; si=dat_to_write[1]; end
			14:begin cs=0; sck=1; si=dat_to_write[1]; end
			15:begin cs=0; sck=0; si=dat_to_write[0]; end
			16:begin cs=0; sck=1; si=dat_to_write[0]; end
			endcase
			
		end
		SPI_CMD_READ:begin
			if(cnt>=17)begin next_state=SPI_STATE_IDLE; end
			else	   begin next_state=SPI_CMD_READ  ; end
			
			case(cnt)
			 1:begin cs=0; sck=0;		out_flag=0;end
			 2:begin cs=0; sck=1; dat_to_send[7]=so; end
			 3:begin cs=0; sck=0;	end
			 4:begin cs=0; sck=1; dat_to_send[6]=so; end
			 5:begin cs=0; sck=0;	end
			 6:begin cs=0; sck=1; dat_to_send[5]=so; end
			 7:begin cs=0; sck=0;	end
			 8:begin cs=0; sck=1; dat_to_send[4]=so; end
			 9:begin cs=0; sck=0;	end
			10:begin cs=0; sck=1; dat_to_send[3]=so; end
			11:begin cs=0; sck=0;	end
			12:begin cs=0; sck=1; dat_to_send[2]=so; end
			13:begin cs=0; sck=0;	end
			14:begin cs=0; sck=1; dat_to_send[1]=so; end
			15:begin cs=0; sck=0;	end
			16:begin cs=0; sck=1; out_dat={dat_to_send[7:1],so}; end
			17:begin cs=0; sck=1;		out_flag=1; 	end
				
			endcase			
		end
		SPI_CMD_CS_0:begin
			if(cnt>=1)begin next_state=SPI_STATE_IDLE; end
			else	   begin next_state=SPI_CMD_CS_0 ; end
			
			case(cnt)
			 1:begin cs=0; sck=0; si=0; end
			endcase
			
		end
		SPI_CMD_CS_1:begin
			if(cnt>=1)begin next_state=SPI_STATE_IDLE; end
			else	   begin next_state=SPI_CMD_CS_1 ; end
			
			case(cnt)
			 1:begin cs=1; sck=0; si=0; end
			endcase
			
		end
		default		:begin
			
		end
		endcase
	end
end


always@(posedge sys_clk or negedge rst)begin
	if(!rst) begin
		current_state<=SPI_STATE_IDLE;
	end
	else 	 begin
		
		current_state<=next_state;
		
		case(next_state)
		SPI_STATE_IDLE:begin cnt<=0; end
		SPI_CMD_READ  :begin   if(cnt>=17)begin cnt<=0; end else begin cnt<=cnt+1;end      end
		SPI_CMD_WRITE :begin   if(cnt>=16)begin cnt<=0; end else begin cnt<=cnt+1;end      end
		SPI_CMD_CS_0  :begin   if(cnt>= 1)begin cnt<=0; end else begin cnt<=cnt+1;end      end
		SPI_CMD_CS_1  :begin   if(cnt>= 1)begin cnt<=0; end else begin cnt<=cnt+1;end      end
		default		  :begin cnt<=0; end
		endcase
		
	end
end


endmodule
