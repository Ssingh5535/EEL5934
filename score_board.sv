module score_board #(
    parameter PADDLE_W = 200,
    parameter PADDLE_H = 20,
    parameter HRES = 1280,
    parameter VRES = 720,
    parameter COLOR = 24'hEFE62E
)(
    input pixel_clk,
    input rst,
    input fsync,
    input player_1_scored,
    input player_2_scored,
    input signed [11:0] hpos,
    input signed [11:0] vpos,
    output player_1_win,
    output player_2_win
);

    // Internal registers to keep track of each player's score
    reg [4:0] player_1_score;
    reg [4:0] player_2_score;

    reg player_1_scored_prev;
    reg player_2_scored_prev;

    always @(posedge pixel_clk) begin
        if (rst) begin
            // Reset players' scores
            player_1_score <= 4'b0000;
            player_2_score <= 4'b0000;
            player_1_scored_prev <= 1'b0;
            player_2_scored_prev <= 1'b0;
        end else begin
            // Increment player 1's score on rising edge of player_1_scored
            if (player_1_scored && !player_1_scored_prev) begin
                player_1_score <= player_1_score + 1;
            end

            // Increment player 2's score on rising edge of player_2_scored
            if (player_2_scored && !player_2_scored_prev) begin
                player_2_score <= player_2_score + 1;
            end

            // Update previous values
            player_1_scored_prev <= player_1_scored;
            player_2_scored_prev <= player_2_scored;
        end
    end

    // Determine if player 1 has won
    assign player_1_win = (player_1_score == 4'b1010) ? 1'b1 : 1'b0;
    // Determine if player 2 has won
    assign player_2_win = (player_2_score == 4'b1010) ? 1'b1 : 1'b0;

endmodule
