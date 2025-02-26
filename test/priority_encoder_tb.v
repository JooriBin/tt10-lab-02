module testbench;
    reg [7:0] A, B;
    wire [7:0] C;
    
    priority_encoder uut (
        .A(A),
        .B(B),
        .C(C)
    );

    initial begin
        // Test case 1: In = 0010 1010 1111 0001 → Expected C = 13 (0000 1011)
        A = 8'b00101010;
        B = 8'b11110001;
        #10;
        $display("In = %b%b, C = %b", A, B, C);
        
        // Test case 2: In = 0000 0000 0000 0001 → Expected C = 0 (0000 0000)
        A = 8'b00000000;
        B = 8'b00000001;
        #10;
        $display("In = %b%b, C = %b", A, B, C);
        
        // Test case 3: In = 0000 0000 0000 0000 → Expected C = 0xF0 (1111 0000)
        A = 8'b00000000;
        B = 8'b00000000;
        #10;
        $display("In = %b%b, C = %b", A, B, C);
        
        $stop;
    end
endmodule
