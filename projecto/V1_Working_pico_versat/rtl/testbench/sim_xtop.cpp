#include "Vxtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
int main(int argc, char** argv, char** env) {
  Verilated::commandArgs(argc, argv);
  Verilated::traceEverOn(true);
  
  Vxtop* top = new Vxtop;
  VerilatedVcdC* tfp = new VerilatedVcdC;
  
  top->trace (tfp, 99);
  tfp->open ("Sim.vcd");
  
  //Initialize inputs
  top->clk = 1;
  top->rst = 0;
  
  //Initialize parallel interface
  top->par_addr = 0;
  top->par_we = 0;
  top->par_in = 0;

  int t, start_time, k = 0;
  int clk_period = 10;
  int r0;
  

  while (!Verilated::gotFinish()) {
    if (t == 2*clk_period || t == 3*clk_period)
      top->rst = 1;
    else 
      top->rst = 0;
    if (t == 12*clk_period || t == 13*clk_period) {
      top->par_addr = 0;
      top->par_we = 1;
      top->par_in = 1; //must be non-zero to jump to main program
      start_time = t;
    }
    if (t == 14*clk_period || t == 15*clk_period) {
      top->par_we = 0;
      top->par_addr = 0;
    }
    
    if (t > 16*clk_period && top->par_out == 0) Verilated::gotFinish(true);

    top->clk = !top->clk;
    top->eval();
    tfp->dump(t);
    
    //Clock period / 2
    t += clk_period/2;


  }

  printf("Execution time in clock cycles: %0d \n", (t-start_time)/10);


  tfp->close();
  top->final();
  delete top;
  exit(0);
}
