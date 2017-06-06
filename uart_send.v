module uart_send(

	input sys_clk,
	input rst,
	
	input [7:0] in_dat,
	input in_flag	,
	
	output reg txd,
	output busy
);

reg[7:0] send_cnt;
reg[31:0] cnt_send_clk;
// sys_clk's freq should be  baud*16
reg[31:0] cnt_sys_clk;

wire pos_detect;
reg valid;//means should receive data

reg last_in_flasg;
always@(posedge sys_clk or negedge rst)begin
	if(!rst)begin	last_in_flasg<=1'b1;	end
	else 	begin	last_in_flasg<=in_flag;	end
end

assign pos_detect = (!rst)?0:(  (!last_in_flasg)&in_flag );

reg[7:0] dat_to_send;
always@(posedge sys_clk or negedge rst) if(!rst)dat_to_send<=0;else if(!valid) dat_to_send<=in_dat;

assign busy= (rst) & ( (cnt_send_clk!=0) | pos_detect );

always@(posedge sys_clk or negedge rst)begin
	if(!rst)begin  
		valid<=0;
	end
	else begin
		if(pos_detect)valid<=1;
		else if(cnt_send_clk>=143)valid<=0;
	end
end

always@(posedge sys_clk or negedge rst)begin
	if(!rst)begin  
		send_cnt<=0; cnt_send_clk<=0; txd<=1; //txd default state must be 1
	end
	else begin
		if(valid|pos_detect)begin
			if(cnt_send_clk<160)cnt_send_clk<=cnt_send_clk+1'b1;
			
			case(cnt_send_clk)
			  0:begin txd<=0; end
			 16:begin txd<=dat_to_send[0];dat_to_send<=dat_to_send>>1'b1; end
			 32:begin txd<=dat_to_send[0];dat_to_send<=dat_to_send>>1'b1; end
			 48:begin txd<=dat_to_send[0];dat_to_send<=dat_to_send>>1'b1; end
			 64:begin txd<=dat_to_send[0];dat_to_send<=dat_to_send>>1'b1; end
			 80:begin txd<=dat_to_send[0];dat_to_send<=dat_to_send>>1'b1; end
			 96:begin txd<=dat_to_send[0];dat_to_send<=dat_to_send>>1'b1; end
			112:begin txd<=dat_to_send[0];dat_to_send<=dat_to_send>>1'b1; end
			128:begin txd<=dat_to_send[0];dat_to_send<=dat_to_send>>1'b1; end
			
			144:begin txd<=1; end
			
			endcase
		end
		else begin
			cnt_send_clk<=0; txd<=1;
		end
	end
end



endmodule
