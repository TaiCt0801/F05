`timescale 1ns/1ps

module tb_F05;

    reg clk;
    reg rst_n;
    reg [3:0] ui_in;
    wire [7:0] uo_out;

    F05 uut (
        .clk(clk),
        .rst_n(rst_n),
        .ui_in(ui_in),
        .uo_out(uo_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_F05);

        clk = 0;
        rst_n = 0;
        ui_in = 4'b0000;

        // RESET
        #10;
        rst_n = 1;

        // TEST 1: Yeu cau mot tang
        // Floor 3

        $display("TEST 1: Yeu cau tang 3");

        ui_in = 4'b0100;
        #10;
        ui_in = 4'b0000;

        #80;

        // TEST 2: Nhieu tang dong thoi
        // Floor 2 + Floor 4

        $display("TEST 2: Yeu cau tang 2 va 4");

        ui_in = 4'b1010;
        #10;
        ui_in = 4'b0000;

        #120;

        // TEST 3: Yeu cau tang vua di qua

        $display("TEST 3: Yeu cau tang vua di qua");

        // Yeu cau Floor 4
        ui_in = 4'b1000;
        #10;
        ui_in = 4'b0000;

        // Cho elevator di tu Floor 2 -> Floor 3
        #30;

        // Luc nay elevator da roi Floor 2
        // Yeu cau lai Floor 2
        ui_in = 4'b0010;
        #10;
        ui_in = 4'b0000;

        #100;

        // TEST 4: Yeu cau tai tang hien tai

        $display("TEST 4: Yeu cau tai tang hien tai");

        ui_in = 4'b0010;
        #10;
        ui_in = 4'b0000;

        #30;

        $display("=================================");
        $display("SIMULATION FINISHED");
        $display("=================================");

        $finish;
    end

    always @(posedge clk) begin
        $display(
            "Time=%0t | Req=%b | Floor=%b | Dir=%b | Door=%b | State=%b",
            $time,
            ui_in,
            uo_out[1:0],
            uo_out[3:2],
            uo_out[4],
            uo_out[7:5]
        );
    end

endmodule