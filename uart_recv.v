module uart_recv(

	input sys_clk,
	input rst,
	
	input  rxd,
	
	output reg[7:0] out_dat,
	output reg out_flag
);

reg[7:0] recv_cnt;

// sys_clk's freq should be  baud*16
reg[31:0] cnt_sys_clk;
reg[15:0] rxd_low,rxd_high;
reg valid;//means should receive data

always@(posedge sys_clk or negedge rst)begin
	if(!rst)begin  
		cnt_sys_clk<=0; rxd_low<=0; rxd_high<=0; valid<=0;
	end
	else begin
	
		if(rxd)begin
			rxd_low<=0;
			if(rxd_high<160)begin rxd_high<=rxd_high+1'b1; end
		end 
		else begin
			rxd_high<=0;
			if(rxd_low<160)begin rxd_low<=rxd_low+1'b1; end
		end
		
		if(rxd_low>=8)begin valid<=1; end
		else if(recv_cnt>=9)begin valid<=0; end
		else if(rxd_high>=150)begin valid<=0; end
		
	end
end



reg[7:0] recv_buf;
reg[31:0] cnt_recv_clk;
always@(posedge sys_clk or negedge rst)begin
	if(!rst)begin
		recv_cnt<=0; recv_buf<=0; cnt_recv_clk<=0;
	end
	else begin
		if(valid)begin
			cnt_recv_clk<=cnt_recv_clk+1'b1;
			
			case(cnt_recv_clk)
			  0:begin									recv_cnt<=0; 			out_flag<=0; end
			 16:begin   recv_buf<={rxd,recv_buf[7:1]};  recv_cnt<=recv_cnt+1'b1;  end
			 32:begin   recv_buf<={rxd,recv_buf[7:1]};  recv_cnt<=recv_cnt+1'b1;  end
			 48:begin   recv_buf<={rxd,recv_buf[7:1]};  recv_cnt<=recv_cnt+1'b1;  end
			 64:begin   recv_buf<={rxd,recv_buf[7:1]};  recv_cnt<=recv_cnt+1'b1;  end
			 80:begin   recv_buf<={rxd,recv_buf[7:1]};  recv_cnt<=recv_cnt+1'b1;  end
			 96:begin   recv_buf<={rxd,recv_buf[7:1]};  recv_cnt<=recv_cnt+1'b1;  end
			112:begin   recv_buf<={rxd,recv_buf[7:1]};  recv_cnt<=recv_cnt+1'b1;  end
			128:begin   recv_buf<={rxd,recv_buf[7:1]};  recv_cnt<=recv_cnt+1'b1;  end
			139:begin		out_dat<=recv_buf;			recv_cnt<=recv_cnt+1'b1;  end
			140:begin									recv_cnt<=0;			 out_flag<=1; end
			endcase
			
		end
		else begin
			recv_cnt<=0;  cnt_recv_clk<=0;
		end
	end
end

endmodule
