module priority_encoder (
    input [7:0] A,  // Upper 8 bits
    input [7:0] B,  // Lower 8 bits
    output reg [7:0] C // Output position of first '1' or 0xF0 if none
);

    reg [15:0] In; // Combined input
    integer i;

    always @* begin
        In = {A, B};  // Combine A and B into a single 16-bit input
        C = 8'hF0;    // Default case: if no '1' is found, return 0xF0

        // Scan from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            if (In[i]) begin
                C = i; // Store the first found '1' position
                break; // Stop searching
            end
        end
    end

endmodule
