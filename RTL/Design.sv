module alu(
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic [2:0] op_code,
    output logic [3:0] y,
    output logic carry,
    output logic zero
);

    logic [4:0] temp;

    always_comb begin

        // Default values
        y     = 4'b0000;
        carry = 1'b0;
        temp  = 5'b00000;

        case (op_code)

            3'b000: begin       // ADD
                temp  = a + b;
                y = temp[3:0];
              carry = temp[4];//only carry bit
            end

            3'b001: begin       // SUBTRACT
                y = a - b;
            end

            3'b010: begin       // AND
                y = a & b;
            end

            3'b011: begin       // OR
                y = a | b;
            end

            3'b100: begin       // XOR
                y = a ^ b;
            end

            3'b101: begin       // NOT A
                y = ~a;
            end

            3'b110: begin       // LEFT SHIFT
                y = a << 1;
            end

            3'b111: begin       // RIGHT SHIFT
                y = a >> 1;
            end

            default: begin
                y = 4'b0000;
            end

        endcase

        // Zero flag
        if (y == 4'b0000)
            zero = 1'b1;
        else
            zero = 1'b0;

    end

endmodule
