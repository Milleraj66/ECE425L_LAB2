`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// AUTHOR: ARTHUR J. MILLER & Bibek B.
// Module Name: ALU
// Create Date: 10/13/2015 04:32:02 PM
// ECE425L LAB #2
// Purpose: 

// Variables:
//              X, Y: are two input words
//              Out : is the output word result, 
//              Cin : is  the carry in bit, 
//              Cout : is the carryout bit.
//              Lt, Eq, Gt: are comparison indicator bits(for less than, equal, and greater than)
//              Ov: is the overflow indicator
//              Opcode: is the operation select ion [2:0]

//          TODO: Overflow flag
//          TODO: Lt,Eq,Gt flag
//          TODO: BNE module
//          TODO: Set lt flag module
//          TODO: set carry out flag
//          TODO: Verify Mux working

//////////////////////////////////////////////////////////////////////////////////

//         input1(16b),input2(16b),Output(16b),CarryIn,CarryOut,LessThan,EqualTo,GreaterThan,Overflow,Opcode 
module ALU(X          ,Y          ,Out        ,Cin    ,Cout    ,Lt      ,Eq     ,Gt         ,Ov      ,Opcode);
    // inputs
    input [15:0] X,Y;
    input Cin;
    input [2:0] Opcode;
    // ouputs
    output Cout,Lt,Eq,Gt,Ov;
    output [15:0] Out;
    // intermediate connections
    wire [7:0] EN_DIS;// Enable/Disable operations. ouput of decoder
    wire [15:0] Z1,Z2,Z3,Z4;
    wire C1, C2; // Carry Out bits for FA and FA w/2's
    
    // 1. Use Opcode input to select operation
    // A Decoder will enable the selected Opcode and disable the rest
    // Logic is high wo we will invert the outputs                
    // Decoder is always enabled
    
    // DONT NEED DECODER
    //                                       Enable,Input(3b),Output(8b)                
    //Decoder_3to8            DECODER1        (1'b0  ,Opcode   ,EN_DIS);    
    //not                     NOT1            (EN_DISn,EN_DIS);
    
    // 2. Use input data X and Y to perform ALU operation
   
    //                                       input1(16b),input2(16b),CarryIn,CarryOut,Output(16b)
    // OPERATION 000: unsigned addition
    FullAdder_16bit         FA              (X          ,Y          ,Cin    ,Cout    ,Z1);
    //                                       input1(16b),input2(16b),CarryIn,CarryOut,Output(16b)
    // OPERATION 001: 2's complement add/sub
    FullAdder2s_16bit       FA_2s           (X          ,Y          ,Cin    ,C2      ,Z2);             
    //                                       input1(16b),input2(16b),output(16b) 
    AND_Bitwise             AND_B1          (X          ,Y          ,Z3);
    //                                       input1(16b),input2(16b),output(16b) 
    OR_Bitwise              OR_B1           (X          ,Y          ,Z4);
    
    
    // Cout flag
    //or                      OR1             (Cout,C1,C2);
    
    
    // 3. Output the solution
    //                   Enable,Select,Input1,Input2,Input3,Input4,Input5,Input6,Input7,input8, Output
    Mux16bit_8to1            MUX1           (E     ,   S  , X0,X1,X2,X3,X4,X5,16'b0,16'b0, Z);
endmodule
