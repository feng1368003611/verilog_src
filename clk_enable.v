//author: FengMeiWen
//date: 2017-6-6 , 10:31
//module function : output clock enable signal ,rather than output divided clock signal,
//	this is helpful for timing-closure in high frequence situation

module clk_enable(
	input  in_clk , 
	input  in_rst_n ,
	
	output out_clk ,
	output reg out_clk_en ,
	
);

parameter DIV=6;
parameter CNT_STD=DIV-1;
parameter OUT_STD=DIV-2;

// 6 分频  ，计数到 4就使能
assign out_clk=in_clk;

reg[3:0] cnt;

always@(posedge in_clk or negedge in_rst_n)begin
	if(~in_rst_n)begin
		cnt<=0; out_clk_en<=0;
	end
	else begin
		if(cnt>=CNT_STD)begin cnt<=0; 	   end
		else 			 begin cnt<=cnt+1'b1; end
		
		if(cnt==OUT_STD)begin out_clk_en<=1; end
		else	   		 begin out_clk_en<=0; end
	end
end




endmodule

