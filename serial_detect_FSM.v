module serial_detect(

	input sys_clk,
	input dat_in,
	
	input rst,
	
	output reg find

);

//to detect serial 1101
//          state  1234  ,idle state is 0

reg [15:0] current_state , next_state ;


always@(*)begin
	if(!rst)begin next_state=0; end
	else 	begin 
		case(current_state)
		0:begin  if(dat_in)next_state=1;else next_state=0;  end
		1:begin  if(dat_in)next_state=2;else next_state=0;  end
		2:begin  if(dat_in)next_state=0;else next_state=3;  end
		3:begin  if(dat_in)next_state=4;else next_state=0;  end
		4:begin  if(dat_in)next_state=1;else next_state=0;  end
		
		default:begin   next_state=0; end
		
		endcase
	end
end

always@(posedge sys_clk or negedge rst)begin

	if(!rst)begin  
		find<=0; current_state<=0;
	end
	else begin
		
		current_state<=next_state;
		
		case(next_state)
		0:begin  find<=0;  end
		1:begin  find<=0;  end
		2:begin  find<=0;  end
		3:begin  find<=0;  end
		4:begin  find<=1;  end
		
		default:begin  find<=0; end
		
		endcase
	end

end



endmodule
