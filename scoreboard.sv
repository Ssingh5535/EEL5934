
module scoreboard #( 
parameter PADDLE_W = 200,
parameter PADDLE_H = 20,
parameter HRES = 1280,
parameter VRES = 720,
parameter COLOR = 24'h EFE62E
)

    (
        input pixel_clk,
        input rst,
        input fsync,
        //Tells scoreboard if a player has scored 
        input player_1_scored,
        input player_2_scored,
        input signed [11:0] hpos, 
        input signed [11:0] vpos, 

        //Pixel output for scoreboard
        output [7:0] pixel [0:2] ,  
        //Output signals to let the top.sv know a player won
        output player_1_win,
        output player_2_win,
        output active         
        
    );

    //Internal registers to keep track of each players score
    reg [4: 0] player_1_score;
    reg [4: 0] player_2_score;

    //localparam BOT_SCORE_VPOS = VRES - 20;
    
    always @(posedge pixel_clk)
     
    begin 
        if(rst) begin 
            //Reset players score
            player_1_score <= 4'b0000;
            player_2_score <= 4'b0000;
        end else if (fsync) begin
                //Player 2 scored
                if(player_2_scored)begin
                        player_2_score <= player_2_score + 4'b0001;
                end 
                //Player 1 scored
                else if(player_1_scored)begin
                        player_1_score <= player_1_score + 4'b0001;
                end 
      end
    end
    //Currently we aren't outputing the internal score to the screen
    assign active = 1'b0;
    /* If active is high, set the RGB values for neon green */
    assign pixel [ 2 ] = (active) ? COLOR [ 23 : 16 ] : 8 'h00; //red 
    assign pixel [ 1 ] = (active) ? COLOR [ 15 : 8 ] : 8 'h00; //green 
    assign pixel [ 0 ] = (active) ? COLOR [ 7 : 0 ] : 8 'h00; //blue 
    assign player_1_win = (player_1_score == 4'b0110) ? 1'b1 : 1'b0 ;
    assign player_2_win = (player_2_score == 4'b0110) ? 1'b1 : 1'b0 ;
                         
            
endmodule
