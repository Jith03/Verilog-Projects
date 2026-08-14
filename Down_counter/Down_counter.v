module Down_counter(
    input wire  clock,
    input wire [3:0] in,
    input wire latch,
    input wire dec,
    output reg [3:0] counter,
    output wire zero
);  

    always @(posedge clock) 
    begin
        if (latch)
            begin
                counter <= in;
            end
        else if (dec && !zero)
            begin
                counter <= counter - 4'b0001;
            end
        else
            begin
                counter <= counter;
            end
    end
    assign zero = (counter == 4'b0);

    
endmodule
