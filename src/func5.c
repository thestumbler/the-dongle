
// input:    x in mem[0x23]
// output:   none
// function: delays x * 2 milliseconds
void sleep2x( void ) {
  off = 0x23; // fsr = 0x43 = Common RAM + 0x23, serial character?
  while( mem[off] != 0 ) return;
    mem[1] = 0x01;
    while{ mem[1] != 0 ) { // 2 * (764+222+5)  = 1.982
      mem[0] = 0xbf; // 191 * 4 * 1 us = 764 us
      while{ mem[0] != 0 ) { // 4 cycles
        clearwdr();
        mem[0]--;
      }
      mem[0] = 0x4a; // 74 * 3 * 1 us = 222 us
      while{ mem[0] != 0 ) { // 3 cycles
        mem[0]--;
      }
      mem[1]--; // 5 cycles
    } 
    mem[off]--; // 5 cycles
  }
}

void init_sys( void ) {
  off = 0x00; // Common_RAM + 0
  mem[off] = 0x0d;

  off = 0x81; // fsr for option_reg
  // lots of option_reg manipulation
  presaler assigned to timer0 module;

  mem[0x03] = upper nibble of option_reg;
  
  // setup GP2 as output
  gp2 = 1; // turn off LED 

}
