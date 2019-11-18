`timescale 1ns / 1ps

module disp_test(
    input clock_100Mhz, // 100 Mhz clock source on Basys 3 FPGA
    input reset, // reset
	 input [7:0] bin,
    output reg [3:0] Anode_Activate, // anode signals of the 7-segment LED display
    output reg [6:0] disp// cathode patterns of the 7-segment LED display
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
reg [29:0]shifter=0;
integer i;

reg [3:0] ones = 0;
reg [3:0] tens = 0;
reg [3:0] hundreds = 0;
reg [3:0] thousands = 0;
reg [13:0] binary = 8'd120;




//input ports and their sizes
    //reg [7:0] bin = 8'b00000111;
    //Internal variables
    reg [11 : 0] bcd; 
    reg [3:0] j;  




always @(posedge clock_100Mhz or posedge reset)
   if(reset==1)
        one_second_counter <= 0;
   else begin
        if(one_second_counter>=99999999) 
            one_second_counter <= 0;
      else
            one_second_counter <= one_second_counter + 1;
    end


assign one_second_enable = (one_second_counter==99999999)?1:0;


always @(posedge clock_100Mhz or posedge reset)
   if(reset==1)
        displayed_number <= 0;
   else if(one_second_enable==1)
      displayed_number <= displayed_number + 1;
  

always @(posedge clock_100Mhz or posedge reset)    
    if(reset==1)
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
    shifter [13:0] = binary;
   
    for (i = 0; i< 14; i = i+1) 
     begin
        if (shifter[17:14] >= 5)
            shifter[17:14] = shifter[17:14] + 3;
        if (shifter[21:18] >= 5)            
            shifter[21:18] = shifter[21:18] + 3;
        if (shifter[25:22] >= 5)            
            shifter[25:22] = shifter[25:22] + 3;
        if (shifter[29:26] >= 5)              
            shifter[29:26] = shifter[29:26] + 3;
        shifter = shifter  << 1;    
    end  
     
    thousands = shifter[29:26];
    hundreds = shifter[25:22];
    tens = shifter[21:18];
    ones = shifter[17:14];
     
    case(LED_activating_counter)
		2'b00: 
			begin
				Anode_Activate = 4'b1110;
				case(bcd[3:0])
					4'd0: disp = 7'b1000000;     //1 - LED DISABLE , 0 - LED ENABLE
					4'd1: disp = 7'b1111001;
					4'd2: disp = 7'b0100100;
					4'd3: disp = 7'b0110000;
					4'd4: disp = 7'b0011001;
					4'd5: disp = 7'b0010010;
					4'd6: disp = 7'b0000010;
					4'd7: disp = 7'b1111000;
					4'd8: disp = 7'b0000000;
					4'd9: disp = 7'b0010000;
            endcase
         end
      2'b01: 
			begin
            Anode_Activate = 4'b1101; 
				case(bcd[7:4])
					4'd0: disp = 7'b1000000;     //1 - LED DISABLE , 0 - LED ENABLE
					4'd1: disp = 7'b1111001;
					4'd2: disp = 7'b0100100;
					4'd3: disp = 7'b0110000;
					4'd4: disp = 7'b0011001;
					4'd5: disp = 7'b0010010;
					4'd6: disp = 7'b0000010;
					4'd7: disp = 7'b1111000;
					4'd8: disp = 7'b0000000;
					4'd9: disp = 7'b0010000;
            endcase
         end
      2'b10: 
			begin
				Anode_Activate = 4'b1011; 
            case(bcd[11:8])
					4'd0: disp = 7'b1000000;     //1 - LED DISABLE , 0 - LED ENABLE
					4'd1: disp = 7'b1111001;
					4'd2: disp = 7'b0100100;
					4'd3: disp = 7'b0110000;
					4'd4: disp = 7'b0011001;
					4'd5: disp = 7'b0010010;
					4'd6: disp = 7'b0000010;
					4'd7: disp = 7'b1111000;
					4'd8: disp = 7'b0000000;
					4'd9: disp = 7'b0010000;
            endcase
		   end
      2'b11: 
		   begin
			   Anode_Activate = 4'b1111;           
			end
    endcase		
		 
end

endmodule