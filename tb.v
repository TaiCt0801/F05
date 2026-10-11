
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

        // RESET BAN DAU
        #10;
        rst_n = 1;

        // TEST 1: YEU CAU TANG 3
        $display("TEST 1: Yeu cau tang 3");
        ui_in = 4'b0100;
        #10;
        ui_in = 4'b0000;
        #80;

        // TEST 2: YEU CAU TANG 2 VA 4
        $display("TEST 2: Yeu cau tang 2 va 4");
        ui_in = 4'b1010;
        #10;
        ui_in = 4'b0000;
        #120;

        // TEST 3: YEU CAU TANG VUA DI QUA
        $display("TEST 3: Yeu cau tang vua di qua");
        ui_in = 4'b1000;
        #10;
        ui_in = 4'b0000;
        #30;
        ui_in = 4'b0010;
        #10;
        ui_in = 4'b0000;
        #100;

        // TEST 4: YEU CAU TANG HIEN TAI
        $display("TEST 4: Yeu cau tang hien tai");
        ui_in = 4'b0010;
        #10;
        ui_in = 4'b0000;
        #30;

        // TEST 5: RESET KHI DANG CHAY
        $display("TEST 5: Reset khi dang chay");
        rst_n = 0;
        ui_in = 4'b0000;
        #10;

        if (uo_out[1:0] == 2'b00 &&
            uo_out[7:5] == 3'b000)
            $display("TEST 5 PASS");
        else
            $display("TEST 5 FAIL");

        rst_n = 1;
        #10;

        // TEST 6: BIEN TANG 4
        $display("TEST 6: Bien tang 4");

        ui_in = 4'b1000;
        #10;
        ui_in = 4'b0000;

        // Cho den khi cua mo hoac het 10 chu ky
        begin : WaitFloor4
            integer i;
            i = 0;

            while (uo_out[4] !== 1'b1 && i < 10) begin
                @(posedge clk);
                #1;
                i = i + 1;
            end

            if (uo_out[1:0] == 2'b11 &&
                uo_out[4] == 1'b1)
                $display("TEST 6 PASS");
            else
                $display("TEST 6 FAIL: Floor=%b Door=%b",
                         uo_out[1:0], uo_out[4]);
        end

        $display("==============================");
        $display("SIMULATION FINISHED");
        $display("==============================");
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
