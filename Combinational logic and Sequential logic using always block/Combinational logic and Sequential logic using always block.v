module DigCt
    (input IN1,
     input IN2,
     input IN3,
     input IN4,
     input CLK,
     output reg OUT1,
     output reg OUT2,
     output reg OUT3
     );

     reg D1, D2, D3;

     always@(posedge CLK)
     begin 

        OUT1 <= D1;
        OUT2 <= D2;
        OUT3 <= D3;

     end

    always @(*)
     begin

        D1 = ~(IN1|IN2);
        D2 = ~(IN2&IN3);
        D3 = IN3|IN4;

     end

     endmodule