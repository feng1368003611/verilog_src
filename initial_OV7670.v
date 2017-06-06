
module initial_OV7670(
	input clk_in,
	input rst,
	
	input in_flag,
	
	inout sccb_sdl,
	
	output sccb_scl,
	output reg finish

);

parameter SCCB_STATE_IDLE	=4'b0000,
		  SCCB_CMD_START	=4'b0001,
		  SCCB_CMD_WRITE	=4'b0010,
		  SCCB_CMD_READ		=4'b0011,
		  SCCB_CMD_STOP		=4'b0110;

reg[7:0] conf_addr[20:0];
reg[7:0] conf_val[20:0];

reg[7:0] index,index_sub;
reg[7:0] in_dat;
reg[3:0] in_cmd;
reg flag;

wire busy;

always@(posedge clk_in or negedge rst)begin

	if(!rst)begin
		finish<=0;  index<=0;index_sub<=0; flag<=0; in_dat<=0; in_cmd<=SCCB_STATE_IDLE;
	end
	else begin
	
	  if((!busy)&in_flag)begin
		if(index<=20)begin
			case(index_sub)
			0:begin  flag<=0; index_sub<=index_sub+1'b1;in_cmd<=SCCB_CMD_START;  end
			1:begin  flag<=1; index_sub<=index_sub+1'b1;	end
			2:begin  flag<=0; index_sub<=index_sub+1'b1;in_cmd<=SCCB_CMD_WRITE; in_dat<=8'h42;  end
			3:begin  flag<=1; index_sub<=index_sub+1'b1;	end
			4:begin  flag<=0; index_sub<=index_sub+1'b1;in_cmd<=SCCB_CMD_WRITE; in_dat<=conf_addr[index]; end
			5:begin  flag<=1; index_sub<=index_sub+1'b1;	end
			6:begin  flag<=0; index_sub<=index_sub+1'b1;in_cmd<=SCCB_CMD_WRITE; in_dat<=conf_val[index]; end
			7:begin  flag<=1; index_sub<=index_sub+1'b1;	end
			8:begin  flag<=0; index_sub<=index_sub+1'b1;in_cmd<=SCCB_CMD_STOP;  end
			
			9:begin  flag<=1; index_sub<=0;	 index<=index+1'b1; end
			endcase
		end
		else begin
			finish<=1;
		end
	  end
		
	end

end

sccb_controller sccb_controller_inst_0(

	. sys_clk(clk_in),
	. rst(rst),
	
	. in_flag(flag),
	
	. in_dat(in_dat),
	. in_cmd(in_cmd),
	
	.  sdl_wire(sccb_sdl),
	.  scl(sccb_scl),
	.  sccb_e(),
	
	. out_dat(),
	. out_flag(),
	. busy(busy)
);


always@(*)begin
	conf_addr[0]<=8'h11; conf_addr[1]<=8'h6b; conf_addr[2]<=8'h2a; conf_addr[3]<=8'h2b;
	conf_addr[4]<=8'h92; conf_addr[5]<=8'h93; conf_addr[6]<=8'h3b; conf_addr[7]<=8'h12;
	conf_addr[8]<=8'h40; conf_addr[9]<=8'h8c; conf_addr[10]<=8'h3a; conf_addr[11]<=8'h67;
	conf_addr[12]<=8'h68; conf_addr[13]<=8'h1e; conf_addr[14]<=8'h17; conf_addr[15]<=8'h18;
	conf_addr[16]<=8'h19; conf_addr[17]<=8'h1a; conf_addr[18]<=8'h32; conf_addr[19]<=8'h03;
	conf_addr[20]<=8'h15;
	
	conf_val[0]<=8'h80; conf_val[1]<=8'h0a; conf_val[2]<=8'h00; conf_val[3]<=8'h00;
	conf_val[4]<=8'h00; conf_val[5]<=8'h00; conf_val[6]<=8'h0a; conf_val[7]<=8'h14;
	conf_val[8]<=8'h10; conf_val[9]<=8'h00; conf_val[10]<=8'h04; conf_val[11]<=8'hc0;
	conf_val[12]<=8'h80; conf_val[13]<=8'h37; conf_val[14]<=8'h16; conf_val[15]<=8'h04;
	conf_val[16]<=8'h02; conf_val[17]<=8'h7b; conf_val[18]<=8'h80; conf_val[19]<=8'h06;
	conf_val[20]<=8'h02;
	
end

endmodule
