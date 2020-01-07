`timescale 1ns / 1ps

module xdispDecoder(
    input clk,
    input rst,
	 input [7:0] bin,
	 input sgn,
    output reg [3:0] disp_select,
    output reg [7:0] disp_value
);


reg [26:0] one_second_counter; // counter for generating 1 second clock enable
wire one_second_enable;// one second enable for counting numbers
reg [15:0] displayed_number; // counting number to be displayed
reg [19:0] refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
                       // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
wire [1:0] LED_activating_counter; 
                 // count     0    ->  1  ->  2  ->  3
                 // activates    LED1    LED2   LED3   LED4
                 // and repeat       
integer i;

//input ports and their sizes
    //reg [7:0] bin = 8'b00000111;
    //Internal variables
    reg [11 : 0] bcd; 
    reg [3:0] j;  




always @(posedge clk or posedge rst)
   if(rst==1)
        one_second_counter <= 0;
   else begin
        if(one_second_counter>=99999999) 
            one_second_counter <= 0;
      else
            one_second_counter <= one_second_counter + 1;
    end


assign one_second_enable = (one_second_counter==99999999)?1:0;


always @(posedge clk or posedge rst)
   if(rst==1)
        displayed_number <= 0;
   else if(one_second_enable==1)
      displayed_number <= displayed_number + 1;
  

always @(posedge clk or posedge rst)    
    if(rst==1)
        refresh_counter <= 0;
   else
      refresh_counter <= refresh_counter + 1;
  
assign LED_activating_counter = refresh_counter[19:18];


always @(bin)
	begin
	bcd = 0; //initialize bcd to zero.
	for (j = 0; j < 8; j = j+1) //run for 8 iterations
		begin
			bcd = {bcd[10:0],bin[7-j]}; //concatenation
             
			//if a hex digit of 'bcd' is more than 4, add 3 to it.  
			if(j < 7 && bcd[3:0] > 4) 
				bcd[3:0] = bcd[3:0] + 3;
			if(j < 7 && bcd[7:4] > 4)
				bcd[7:4] = bcd[7:4] + 3;
			if(j < 7 && bcd[11:8] > 4)
				bcd[11:8] = bcd[11:8] + 3;  
		end
	end  

    
// anode activating signals for 4 LEDs, digit period of 2.6ms
// decoder to generate anode signals 
always @(*)
begin
    case(LED_activating_counter)
		2'b00: 
			begin
				disp_value = 4'b1110;
				case(bcd[3:0])
					4'd0: disp_value = 7'b1000000;     //1 - LED DISABLE , 0 - LED ENABLE
					4'd1: disp_value = 7'b1111001;
					4'd2: disp_value = 7'b0100100;
					4'd3: disp_value = 7'b0110000;
					4'd4: disp_value = 7'b0011001;
					4'd5: disp_value = 7'b0010010;
					4'd6: disp_value = 7'b0000010;
					4'd7: disp_value = 7'b1111000;
					4'd8: disp_value = 7'b0000000;
					4'd9: disp_value = 7'b0010000;
            endcase
         end
      2'b01: 
			begin
            disp_value = 4'b1101; 
				case(bcd[7:4])
					4'd0: disp_value = 7'b1000000;     //1 - LED DISABLE , 0 - LED ENABLE
					4'd1: disp_value = 7'b1111001;
					4'd2: disp_value = 7'b0100100;
					4'd3: disp_value = 7'b0110000;
					4'd4: disp_value = 7'b0011001;
					4'd5: disp_value = 7'b0010010;
					4'd6: disp_value = 7'b0000010;
					4'd7: disp_value = 7'b1111000;
					4'd8: disp_value = 7'b0000000;
					4'd9: disp_value = 7'b0010000;
            endcase
         end
      2'b10: 
			begin
				disp_value = 4'b1011; 
            case(bcd[11:8])
					4'd0: disp_value = 7'b1000000;     //1 - LED DISABLE , 0 - LED ENABLE
					4'd1: disp_value = 7'b1111001;
					4'd2: disp_value = 7'b0100100;
					4'd3: disp_value = 7'b0110000;
					4'd4: disp_value = 7'b0011001;
					4'd5: disp_value = 7'b0010010;
					4'd6: disp_value = 7'b0000010;
					4'd7: disp_value = 7'b1111000;
					4'd8: disp_value = 7'b0000000;
					4'd9: disp_value = 7'b0010000;
            endcase
		   end
      2'b11: 
		   begin
			   disp_value = 4'b1111;
				if(sgn)
				disp_value = 7'b0111111;
				else 
				disp_value = 7'b1111111;
			end
    endcase		
		 
end

endmodule