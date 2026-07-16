//715
module ClockedNegativeOneShot(InputPulse, OneShot, Reset, CLOCK);

input InputPulse, Reset, CLOCK;
output reg OneShot;
parameter State0 = 0, State1 = 1, State2 = 2, State3 = 3;
reg [1:0] State;

always@(State)
    if(State == State1) OneShot <= 0;
    else OneShot <= 1;

always@(posedge CLOCK)
    if(Reset == 1) State <= State0;
    else
        case(State)
            State0: if(InputPulse == 1) State <= State1; else State <= State0;
            State1: if(InputPulse == 1) State <= State0; else State <= State3;
            State2: State <= State0;
            State3: if(InputPulse == 1) State <= State0; else State <= State3;
        endcase

endmodule