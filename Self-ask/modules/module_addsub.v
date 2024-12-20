module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    
    wire [15:0] lower_a, upper_a, lower_b, upper_b;
    wire [15:0] sum_lower, sum_upper;
    wire cout_lower;
    
    assign lower_a = a[15:0];
    assign upper_a = a[31:16];
    assign lower_b = b[15:0] ^ {16{sub}};
    assign upper_b = b[31:16] ^ {16{sub}};
    
    add16 adder_lower (
        .a(lower_a), 
        .b(lower_b), 
        .cin(sub), 
        .sum(sum_lower), 
        .cout(cout_lower)
    );

    add16 adder_upper (
        .a(upper_a), 
        .b(upper_b), 
        .cin(cout_lower), 
        .sum(sum_upper), 
        .cout()
    );
    
    assign sum = {sum_upper, sum_lower};

endmodule