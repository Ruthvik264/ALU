`include "interface.sv"
`include "test.sv"

module top;
  intf i_intf();
  
  test t1(i_intf);
  
  alu a1(
    .a(i_intf.a),
    .b(i_intf.b),
    .op_code(i_intf.op_code),
    .y(i_intf.y),
    .carry(i_intf.carry),
    .zero(i_intf.zero)
  );
  
  initial begin
    $dumpfile("dump.vcd");$dumpvars;
  end
  
endmodule
    