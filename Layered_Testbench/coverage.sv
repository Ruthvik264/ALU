class coverage;
  transaction trans;

  covergroup cg;
    option.per_instance = 1;

    cp_op: coverpoint trans.op_code {
      bins add = {3'b000};
      bins sub = {3'b001};
      bins and_op = {3'b010};
      bins or_op  = {3'b011};
      bins xor_op = {3'b100};
      bins not_op = {3'b101};
      bins shl = {3'b110};
      bins shr = {3'b111};
    }

    cp_a: coverpoint trans.a {
      bins zero = {0};
      bins low  = {[1:7]};
      bins high = {[8:14]};
      bins max  = {15};
    }

    cp_b: coverpoint trans.b {
      bins zero = {0};
      bins low  = {[1:7]};
      bins high = {[8:14]};
      bins max  = {15};
    }

    cp_carry: coverpoint trans.carry;
    cp_zero:  coverpoint trans.zero;

    // every operation with each flag value
    cross_op_zero:  cross cp_op, cp_zero;
    cross_op_carry: cross cp_op, cp_carry {
      ignore_bins no_carry_except_add = cross_op_carry with (cp_op != 3'b000 && cp_carry == 1);
    }
  endgroup

  function new();
    cg = new();
  endfunction

  function void sample(transaction t);
    trans = t;
    cg.sample();
  endfunction
endclass
