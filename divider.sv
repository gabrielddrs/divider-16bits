module int_divider (
    input logic clk, rst_n, start,
    input logic [15:0] dividend,  
    input logic [15:0] divisor,   
    output logic [15:0] quotient, 
    output logic [15:0] remainder,
    output logic done             
);

    typedef enum logic [1:0] {
        IDLE,       
        DIVIDE,     
        DONE        
    } state_t;

    state_t state, next_state;      
    logic [15:0] div_reg, divisor_reg, quotient_reg;
    logic [15:0] counter;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        case (state)
            IDLE: begin
                if (start)
                    next_state = DIVIDE;
                else
                    next_state = IDLE;
            end
            DIVIDE: begin
                if (counter == 16 || div_reg < divisor_reg || divisor_reg == 0)
                    next_state = DONE;
                else
                    next_state = DIVIDE;
            end
            DONE: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_reg      <= 16'b0;
            divisor_reg  <= 16'b0;
            quotient_reg <= 16'b0;
            counter      <= 16'b0;
            done         <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        div_reg      <= dividend;
                        divisor_reg  <= divisor;
                        quotient_reg <= 16'b0;
                        counter      <= 16'b0;
                        done         <= 1'b0;
                    end
                end
                DIVIDE: begin
                    if (divisor_reg != 0) begin  // Verificação de divisão por zero
                        if (div_reg >= divisor_reg) begin
                            div_reg <= div_reg - divisor_reg;
                            quotient_reg <= quotient_reg + 1;
                        end
                        counter <= counter + 1;
                    end
                end
                DONE: begin
                    done <= 1'b1;
                    if (divisor_reg == 0) begin
                        quotient_reg <= 16'b0;  // Opcional: definir quociente como 0 em caso de divisão por 0
                        div_reg <= dividend;     // Opcional: manter o dividendo como resto
                    end
                end
            endcase
        end
    end

    assign quotient  = quotient_reg;
    assign remainder = div_reg;

endmodule
