

module pinpong_fifo(
		input rst ,
		
		input in_flag ,
		input [7:0] in_dat ,
		
		output reg out_flag ,
		output reg[7:0] out_dat ,
		
		output reg empty , // for reader
		output reg full,   // for writer
);

reg[7:0] mem[3*2-1:0];  //6 byte fifo

reg[5:0] rd_ptr,wr_ptr;

reg fifo0_emprt,fifo0_full, 
	fifo1_emprt,fifo1_full;
	
reg[5:0] read_cnt , write_cnt;

reg[5:0] fifo0_rd_cnt,fifo0_wr_cnt,
		 fifo1_rd_cnt,fifo1_wr_cnt;

always@( posedge in_flag or negedge rst )begin
	if(!rst)begin
		write_cnt<=0; wr_ptr<=0;
	end
	else begin
		if(!full)begin
			mem[wr_ptr]<=in_dat; //write to fifo
			if(wr_ptr<3*2-1)wr_ptr<=wr_ptr+1'b1;
			else			wr_ptr<=0;
			write_cnt<=write_cnt+1'b1;
		end
	end
end

always@( posedge out_flag or negedge rst )begin
	if(!rst)begin
		read_cnt<=0; rd_ptr<=0;
	end
	else begin
		if(!empty)begin
			out_dat<=mem[rd_ptr]; //read from fifo
			if(rd_ptr<3*2-1)rd_ptr<=rd_ptr+1'b1;
			else			rd_ptr<=0;
			read_cnt<=read_cnt+1'b1;
		end
	end
end


endmodule
