`timescale 1ns / 1ps   ///se coloco el tiempo de escalado por warning
//Micro - Architecture ALU
// Jeanpaull Valencia Quintero - 2200496
// Carlos Humberto Diaz Salazar - 2182353
module ALU #(parameter n = 32)(
input [n-1:0]SrcA, //input definitions : SrcA and SrcB coming from the Register output data signals
input [n-1:0]SrcB,
input [2:0]ALUControl, // ALU control comes from the main controller
output Zero,                                                                                                       //add new wire
output reg [n-1:0]ALUResult //ALU result gives us the result depending on the operation
);

// Wire declarations, the main reason of the wire declarations is to provide organization to the code

wire [n-1:0]A;
wire [n-1:0]B;

wire [n-1:0]AND; //Main structures
wire [n-1:0]OR;
wire [n-1:0]XOR;
wire [n-1:0]ADD;
wire [n-1:0]SLT;

wire [n-1:0]POST_B; //Support structures
wire PRE_SLT;
wire POST_SLT;


assign A = SrcA;
assign B = SrcB;

//Zero
assign   Zero = (ALUControl[0]==1 & A == B);
// AND STRUCTURE

assign AND[n-1:0] = A & B;

// OR STRUCTURE

assign OR[n-1:0] = A | B;

// XOR STRUCTURE

assign XOR[n-1:0] = A ^ B;

// B signal modifier

assign POST_B[n-1:0] = ALUControl[0]? ~B + 32'd1:B;

// ADDITION AND SUBSTRACTION STRUCTURE

assign ADD[n-1:0] = A+POST_B; // It's controlled by the LSB of the ALU Controller signal

// SLT signal modifier

assign PRE_SLT = (~ALUControl[1]) & (ADD[n-2] ^ A[n-2]) & ~(A[n-2] ^ B[n-2] ^ ALUControl[0]);
assign POST_SLT = PRE_SLT ^ ADD[n-2];

// SET LESS THAN

assign SLT[n-1:0] = {31'd0,POST_SLT};

// MUX

always @(*)
case (ALUControl)
3'd0: ALUResult = ADD;
3'd1: ALUResult = ADD;
3'd2: ALUResult = AND;
3'd3: ALUResult = OR;
3'd4: ALUResult = XOR;
3'd5: ALUResult = SLT;
default: ALUResult = 32'd0;

endcase

endmodule 