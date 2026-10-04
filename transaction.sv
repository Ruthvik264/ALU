class transaction;
  rand bit [3:0] a;
  rand bit [3:0] b;
  rand bit [2:0] op_code;
  
  bit [3:0] y;
  bit carry;
  bit zero;
  
  function void display(string name);
    $display("%s",name);
    $display("a=%0d,b=%0d,op_code=%0d",a,b,op_code);
    $display("y=%0d, carry=%0d, zero=%0d", y, carry, zero);
  endfunction
endclass
             
    
  