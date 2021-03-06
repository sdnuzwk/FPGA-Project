// the whole module concluding all submodules
module frequency(sigin, 
                 testmode, 
                 sysclk, 
                 modecontrol, 
                 highfreq, 
                 cathodes, 
                 AN);

  input sigin, sysclk, modecontrol;
  input [1 : 0] testmode;

  output highfreq;
  output [6 : 0] cathodes;
  output [3 : 0] AN;

  // clear signal is generated by the control module
  // clear is used to reset the counter
  wire sigto, enable, latch, clear, clkscan, clkcont;
  wire [15 : 0] num1, num2;
  
  // if the signal's frequency is too high, divide it
  FrequencyChoose        fc(.signalIn(sigin), 
                            .frequencyControl(modecontrol), 
                            .highFrequency(highfreq), 
                            .signalOut(sigto));
  // generate all clatch needed
  SystemClk              sc(.clk(sysclk), 
                            .clkScan(clkscan), 
                            .clkControl(clkcont));
  // generate control signal
  ControlSignal          cs(.clkControl(clkcont), 
                            .testMode(testmode),
                            .modeControl(modecontrol),
                            .enable(enable), 
                            .latch(latch), 
                            .clear(clear));
  // four decimal counter in one module
  FourBitDecimalCounter  dec(.clk(sigto), 
                             .enable(enable), 
                             .clear(clear), 
                             .num(num1));     // output the number
  // latcher
  Latcher                l(.latch(latch),     // latch the number
                           .inData(num1),
                           .outData(num2));
  // to show the number in leds
  Decoder                de(.clkScan(clkscan), 
                            .inData(num2), 
                            .AN(AN),
                            .out(cathodes));
endmodule
