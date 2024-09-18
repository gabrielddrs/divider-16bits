`include "divider.sv"

module tb_int_divider;
    logic clk, rst_n, start;
    logic [15:0] dividend, divisor;
    logic [15:0] quotient, remainder;
    logic done;

    localparam N = 10;  
    logic [63:0] expectations[N-1:0];  
    logic [15:0] expected_quotient, expected_remainder;

    int_divider uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("divider.vcd");
        $dumpvars(0, tb_int_divider);

        clk = 0;
        start = 0;
        rst_n = 0;
        #10 rst_n = 1;

        $readmemb("expectations.txt", expectations);

        for (int i = 0; i < N; i++) begin
            {dividend, divisor, expected_quotient, expected_remainder} = expectations[i];
            start = 1;

            @(posedge clk);
            start = 0;
            wait(done);

            if (quotient !== expected_quotient || remainder !== expected_remainder) begin
                $error("Erro no caso de teste %0d: dividend=%b divisor=%b. Expected quotient=%b remainder=%b, but got quotient=%b remainder=%b", 
                    i, dividend, divisor, expected_quotient, expected_remainder, quotient, remainder);
            end else begin
                $display("Caso de teste %0d passou! Dividend=%b, Divisor=%b, Quotient=%b, Remainder=%b", 
                    i, dividend, divisor, quotient, remainder);
            end

            @(posedge clk);
        end

        $finish;
    end

endmodule
