

module count_1 #(
	parameter IN_LEN = 32 ,
			   OUT_LEN=5+1 

)
(
	input[IN_LEN-1:0] in_dat ,
	input in_rst ,
	output reg[OUT_LEN-1:0] out_1_cnt
);

reg [OUT_LEN-1:0]cnt;

always@(*)begin
	if(!in_rst)begin
		out_1_cnt=0;
	end
	else begin
		cnt=0;
		out_1_cnt=0;
		for(cnt=0;cnt<IN_LEN;cnt=cnt+1)begin
			if(in_dat[cnt] )begin out_1_cnt=out_1_cnt+1; end
		end
	end
end


endmodule

