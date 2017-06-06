module lpf_tb();


	reg sys_clk;
	reg rst;

	
	reg[7:0] in_dat;


	reg [31:0] cnt;
	

	wire[7:0] out_dat;

	
	reg[7:0] dat_to_lpf[0:100];
	
	
	initial begin
		sys_clk=0;
		rst=0;

		in_dat=0;

		cnt=0;
		$readmemh("C:/Users/Administrator.USER-20161213LK/Desktop/matlab53 75M/MATLAB/work/feng/value.txt",dat_to_lpf);
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
			
			cnt<=cnt+1;
			if(cnt>103)begin $stop; end
				in_dat<=dat_to_lpf[cnt];
			end
		
	end
	
lpf lpf_inst_0(

	. clk(sys_clk) ,
	. rst(rst) ,

	. in_dat(in_dat) ,

	. out_dat(out_dat)

);

endmodule
