`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// AUTHOR: ARTHUR J. MILLER & Bibek B.
// Module Name: ALU
// Create Date: 10/13/2015 04:32:02 PM
// Edit 1 Date: 10/15/2015 Arthur J. Miller
// ECE425L LAB #2
// Purpose: The objective of this lab is to develop structural and behavioral models for an ALU. 

// Variables:
//              X, Y: are two input words
//              Out : is the output word result, 
//              Cin : is  the carry in bit, 
//              Cout : is the carryout bit.
//              Lt, Eq, Gt: are comparison indicator bits(for less than, equal, and greater than)
//              Ov: is the overflow indicator: Only gives good ouput for opcode 000,001
//                  The two addition operations
//              Opcode: is the operation selection [2:0]

//          xTODO: Carry Out Flag (currently C1&C2, maybe just take one and make Cout) Both should be same
//          xTODO: Overflow flag
//          xTODO: Lt,Eq,Gt flag
//          xTODO: set carry out flag
//          xTODO: Verify Mux working - Mux was selecting exactly inversly
//          xTODO: Verify first 4 modules work as expected
//          xTODO: BNE module
//          xTODO: Set lt flag module
//          xTODO: Overflow array for 
//          TODO: Lt/Gt might not be working for negative cases? test more im tired?
//          TODO: Test BNE, Lt modules
//          TODO: Implement Mult/Div



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
    wire [15:0] Z0,Z1,Z2,Z3,Z4,Z5,Zeq,ZLt; // output for operation module
    wire C1; // Carry Out bit for FA
    wire nSignBit,nEq, CoutLt,OvLt, TmpGt, TmpLt;
    wire [1:0] Ov_adders; 

    //****************************************************************************************
    // 1. Use input data X and Y to perform ALU operation
    // OPERATION 000: unsigned addition
    //                                       input1(16b),input2(16b),CarryIn,CarryOut,Overflow      ,Output(16b)
    FullAdder_16bit         FA              (X          ,Y          ,Cin    ,C1      , Ov_adders[0] ,Z0);
    // OPERATION 001: 2's complement add/sub    
    //                                           input1(16b),input2(16b),CarryIn,CarryOut, Overflow  ,Output(16b)
    FullAdder2s_16bit       FA_2s           (X          ,Y          ,Cin    ,Cout     , Ov_adders[1]        ,Z1);             
    // OPERATION 001: Bitwise AND
    //                                       input1(16b),input2(16b),output(16b) 
    AND_Bitwise             AND_B1          (X          ,Y          ,Z2);
    // OPERATION 011: Bitwise OR
    //                                       input1(16b),input2(16b),output(16b) 
    OR_Bitwise              OR_B1           (X          ,Y          ,Z3);
    // OPERATION 100: Set Flag if Less than
    //                                       input1(16b),input2(16b),Flag(16b)
    Lt                      LT1             (X          ,Y          ,Z);
    // OPERATION 101: Branch If Not Equal To
    //                                       input1(16b),input2(16b),Flag(16b)
    BNE                     BNE1            (X          ,Y          ,Z4);
    // OPERATION 110: Unimplemented -> Multiply by 2?
    // OPERATION 111: Unimplemented -> Divide by 2?
    
    //*****************************************************************************************
    // 2. Set Cout,Ov, lt,eq,gt flags X == Y? X<Y? X>Y?
    // a. Set Carry out flag
    //      Using the carry out of 2's comp
    // b. Set Overflow select proper overflow depending on which operation
    //                      Enable,Select   ,Input1       ,Input0       ,Output
    Mux1bit_2to1    MUX_Ov(1'b1   ,Opcode[0], Ov_adders[1], Ov_adders[0], Ov);
    // c. Set Equal to flag: 
    // if XOR'd num == 0 -> Equal, else not eq
    xor XOR1 [15:0] (Zeq,X,Y);
    // Check if number is not zero, if so they are not equal
    or(nEq,Zeq[0],Zeq[1],Zeq[2],Zeq[3],Zeq[4],Zeq[5],Zeq[6],Zeq[7],Zeq[8],Zeq[9],Zeq[10],Zeq[11],Zeq[12],Zeq[13],Zeq[14],Zeq[15]);
    // Correct logic
    not(Eq,nEq);
    // d. Set Less than flag: Check sign bit of 2's comp, 1==LT,0==nLT
    // X-Y = POS/NEG/ZERO. must always minus (CarryIn == 1 -> minus)
    //                                       input1(16b),input2(16b),CarryIn,CarryOut, Overflow  ,Output(16b)
    FullAdder2s_16bit       FA_Lt           (X          ,Y          ,1'b1    ,CoutLt     , OvLt        ,ZLt);    
    or(TmpLt,1'b0,ZLt[15]);
    // Account for if Eq is true for Lt and Gt
    and(Lt,TmpLt,nEq);
    // e. Set Greater than flag: Check sign bit of 2's comp, 1==nGT,0==GT    
    not(nSignBit,ZLt[15]);
    or(TmpGt,1'b0,nSignBit);
    // Account for if Eq is true for Lt and Gt
    and(Gt,TmpGt,nEq);
    
    //****************************************************************************************
    // 3. Output the solution
    // There are not operations for 6,7 opcode so they are set to 0
    // The enable input is set to 1 (there is no disable option for the ALU
    //                                       Enable,Select,Input1,Input2,Input3,Input4,Input5,Input6,Input7,input8, Output
    Mux16bit_8to1            MUX1           (1'b1  ,   Opcode  , Z0,Z1,Z2,Z3,Z4,Z5,16'b0,16'b0, Out);
endmodule
