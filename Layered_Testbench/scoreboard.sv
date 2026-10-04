class scoreboard;
  mailbox mon2scb;

  function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
  endfunction

  task main;
    transaction trans;
    bit [3:0] exp_y;
    bit       exp_c;
    bit       exp_z;
    bit [4:0] temp;
    string    op_name;

    repeat(8)
      begin
        mon2scb.get(trans);

        exp_y = 4'b0000;
        exp_c = 1'b0;
        temp  = 5'b00000;

        case(trans.op_code)

          3'b000: begin             // ADD
                    op_name = "ADD";
                    temp    = trans.a + trans.b;
                    exp_y   = temp[3:0];
                    exp_c   = temp[4];
                  end

          3'b001: begin             // SUB
                    op_name = "SUB";
                    exp_y   = trans.a - trans.b;
                  end

          3'b010: begin             // AND
                    op_name = "AND";
                    exp_y   = trans.a & trans.b;
                  end

          3'b011: begin             // OR
                    op_name = "OR";
                    exp_y   = trans.a | trans.b;
                  end

          3'b100: begin             // XOR
                    op_name = "XOR";
                    exp_y   = trans.a ^ trans.b;
                  end

          3'b101: begin             // NOT
                    op_name = "NOT";
                    exp_y   = ~trans.a;
                  end

          3'b110: begin             // LEFT SHIFT
                    op_name = "LEFT SHIFT";
                    exp_y   = trans.a << 1;
                  end

          3'b111: begin             // RIGHT SHIFT
                    op_name = "RIGHT SHIFT";
                    exp_y   = trans.a >> 1;
                  end

        endcase

        exp_z = (exp_y == 4'b0000);

        if (trans.y == exp_y && trans.carry == exp_c &&  trans.zero == exp_z)
          $display("[SCO][PASS] %s | a=%0d b=%0d | y=%0d carry=%0d zero=%0d",
                   op_name, trans.a, trans.b, trans.y, trans.carry, trans.zero);
        else
          $display("[SCO][FAIL] %s | a=%0d b=%0d | got y=%0d c=%0d z=%0d | exp y=%0d c=%0d z=%0d",
                   op_name, trans.a, trans.b,
                   trans.y, trans.carry, trans.zero,
                   exp_y, exp_c, exp_z);
      end
  endtask
endclass