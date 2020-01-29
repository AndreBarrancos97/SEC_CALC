`timescale 1ns / 1ps

module xdispDecoder(
    input clk,
    input rst,
	input btn2_sel,
	//input [1:0] msg,
	input display_sel,
	//input disp_show_sel,
	input [7:0]Sw,
	input wr_enable,
	input [7:0] bin,
	input sgn,
	input [1:0] dot,
    output reg [3:0] disp_select,
    output reg [7:0] disp_value
);
reg [7:0] bin_reg;

reg [19:0] refresh_counter;       // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
                                  // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
wire [1:0] LED_activating_counter; 
												// count     	0   ->  1  ->  2  ->  3
												// activates    LED1    LED2   LED3   LED4
											   // and repeat       
//reg aux_ii;
reg [11 : 0] bcd; 
reg [3:0] j;  
reg aaa;
reg bbb;
reg [2:0]msg;
always @(posedge rst or posedge clk)
	if(rst)begin
		msg <= 3'b000;
		bin_reg <= 7'b0;
		refresh_counter <= 0;
		aaa <= 1'b0;
		bbb <= 1'b0;
	end
	else if (wr_enable & display_sel)begin
		refresh_counter <= 0;
		bin_reg <= bin[7:0];
		msg <= 3'b000;
		aaa <= 1'b1;
		bbb <= 1'b0;
		end
	else if (btn2_sel)begin
		refresh_counter <= 0;
		bbb <= 1'b1;
		end
	else if (bbb) begin
		bin_reg <= 8'd0;
		msg <= Sw[2:0];
		refresh_counter <= refresh_counter + 1;
	end
	else if (aaa == 1'b0) begin
	  bin_reg <= {1'b0,Sw[6:0]};
      refresh_counter <= refresh_counter + 1;
	end
	else if (aaa) begin
		refresh_counter <= refresh_counter + 1;
	end
assign LED_activating_counter = refresh_counter[19:18];


always @(*)
	begin
	bcd = 0; //initialize bcd to zero.
	for (j = 0; j < 8; j = j+1) //run for 8 iterations
		begin
			bcd = {bcd[10:0],bin_reg[7-j]}; //concatenation
             
			//if a hex digit of 'bcd' is more than 4, add 3 to it.  
			if(j < 7 && bcd[3:0] > 4) 
				bcd[3:0] = bcd[3:0] + 3;
			if(j < 7 && bcd[7:4] > 4)
				bcd[7:4] = bcd[7:4] + 3;
			if(j < 7 && bcd[11:8] > 4)
				bcd[11:8] = bcd[11:8] + 3;  
		end
	end  

reg [4:0] aux;
reg [1:0] disp_dot = 1'b0;

//always @(led0_sel)
always @*
	begin
	
	case(aux)				//igfedcba
		5'd0: disp_value = 8'b11000000;  //0      //1 - LED DISABLE , 0 - LED ENABLE
		5'd1: disp_value = 8'b11111001;  //1
		5'd2: disp_value = 8'b10100100;  //2
		5'd3: disp_value = 8'b10110000;  //3
		5'd4: disp_value = 8'b10011001;  //4
		5'd5: disp_value = 8'b10010010;  //5
		5'd6: disp_value = 8'b10000010;  //6
		5'd7: disp_value = 8'b11111000;  //7
		5'd8: disp_value = 8'b10000000;  //8
		5'd9: disp_value = 8'b10010000;  //9
		5'd10: disp_value = 8'b10111111; //-
		5'd11: disp_value = 8'b10010010; //S
		5'd12: disp_value = 8'b11000001; //U
		5'd13: disp_value = 8'b11001000; //M
		5'd14: disp_value = 8'b10100001; //D
		5'd15: disp_value = 8'b11001111; //I
		5'd16: disp_value = 8'b11000111; //L
		5'd17: disp_value = 8'b11111111; //nan
		default: disp_value = 8'b11111111; //nan
   endcase
	
	if(disp_dot == 1'b1)
		disp_value[7] = 1'b0;
	end 
	

// anode activating signals for 4 LEDs, digit period of 2.6ms
// decoder to generate anode signals 
always @(*)
begin
    disp_dot = 1'b0;
    case(LED_activating_counter)
		2'b00: 
			begin
				disp_select = 4'b1110;
				if(msg == 2'b00)
					aux = bcd[3:0];
				else 
					aux = 5'd18; //turn off 
			end
      2'b01: 
			begin
            disp_select = 4'b1101;
				if(msg == 3'b000)begin
					if(dot == LED_activating_counter) 
						disp_dot = 1'b1;
					aux = bcd[7:4];
				end else if(msg == 3'b001)begin //message is SUM
					aux = 5'd13; //print S on 2th display
				end else if(msg == 3'b010) begin //message is MUL
					aux = 5'd16; //print L on 2th display
				end else if(msg == 3'b100) begin //message is DIV
					aux = 5'd12; //print " " on 2th display
				end 
            end
      2'b10: 
			begin
				disp_select = 4'b1011;
				if(msg == 3'b000)begin
					if(dot == LED_activating_counter) 
						disp_dot = 1'b1;				
					aux = bcd[11:8];
				end else if(msg == 3'b001)begin //message is SUM
					aux = 5'd12; //print U on 3th display
				end else if(msg == 3'b010)begin //message is MUL
					aux = 5'd12; //print A on 3th display
				end else if(msg == 3'b100)begin //message is DIV
					aux = 5'd15; //pront P on 3th display
				end
		    end
      2'b11: 
		   begin
			   disp_select = 4'b0111;
				if(msg == 3'b000)begin
					if((sgn == 1) & (aaa==1))
						aux = 5'd10; //display "-"
					else if((Sw[7] == 1) & (aaa==0))
						aux = 5'd10; //display "+"
					else if((Sw[7] == 0) & (aaa==0))
						aux = 5'd18; //display "+"
					else if((sgn == 0) & (aaa==1))
						aux = 5'd18; //display "-"
				end else if(msg == 3'b001)begin //message is SUM
					aux = 5'd11; //print M on 4th display
				end else if(msg == 3'b010)begin //message is MUL
					aux = 5'd13; //print V on 4th display
				end else if(msg == 3'b100)begin //message is DIV
					aux = 5'd14; //pront O on 4th display
				end
			end
    endcase		
		 
end

endmodule