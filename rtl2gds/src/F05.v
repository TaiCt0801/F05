module F05 (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [3:0] ui_in,
    output wire [7:0] uo_out
);

    localparam IDLE = 2'b00;
    localparam UP   = 2'b01;
    localparam DOWN = 2'b10;
    localparam OPEN = 2'b11;

    reg [1:0] Sate;
    reg [1:0] SNext;

    reg [3:0] Req;
    reg [3:0] RNext;

    reg [1:0] Flr;
    reg [1:0] FNext;

    always @(*) begin

        SNext = Sate;
        FNext = Flr;
        RNext = Req | ui_in;

        case (Sate)

            IDLE: begin
                if (Req[Flr]) begin
                    SNext = OPEN;
                    RNext[Flr] = 1'b0;
                end
                else if (Req != 4'b0000) begin
                    if (Req[3] || Req[2])
                        SNext = UP;
                    else
                        SNext = DOWN;
                end
            end

            UP: begin
                if (Req[Flr]) begin
                    SNext = OPEN;
                    RNext[Flr] = 1'b0;
                end
                else if (Flr < 2'b11) begin
                    FNext = Flr + 1'b1;
                end
                else if (Req[2:0] != 3'b000) begin
                    SNext = DOWN;
                end
                else begin
                    SNext = IDLE;
                end
            end

            DOWN: begin
                if (Req[Flr]) begin
                    SNext = OPEN;
                    RNext[Flr] = 1'b0;
                end
                else if (Flr > 2'b00) begin
                    FNext = Flr - 1'b1;
                end
                else if (Req[3:1] != 3'b000) begin
                    SNext = UP;
                end
                else begin
                    SNext = IDLE;
                end
            end

            OPEN: begin
                if (RNext != 4'b0000) begin
                    if (RNext[3] || RNext[2])
                        SNext = UP;
                    else
                        SNext = DOWN;
                end
                else begin
                    SNext = IDLE;
                end
            end

            default: begin
                SNext = IDLE;
                FNext = 2'b00;
            end

        endcase
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            Sate <= IDLE;
            Flr  <= 2'b00;
            Req  <= 4'b0000;
        end
        else begin
            Sate <= SNext;
            Flr  <= FNext;
            Req  <= RNext;
        end
    end

    assign uo_out[1:0] = Flr;

    assign uo_out[3:2] =
        (Sate == UP)   ? 2'b01 :
        (Sate == DOWN) ? 2'b10 :
                         2'b00;

    assign uo_out[4] = (Sate == OPEN);

    assign uo_out[7:5] =
        (Sate == IDLE) ? 3'b000 :
        (Sate == UP)   ? 3'b001 :
        (Sate == DOWN) ? 3'b010 :
                         3'b011;

endmodule