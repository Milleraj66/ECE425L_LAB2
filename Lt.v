`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// AUTHOR: ARTHUR J. MILLER & Bibek B.
// Module Name: Lt
// Create Date: 10/15/2015 08:51:58 PM
// ECE425L LAB #2
// Purpose: Send flage if X is less than Y
//          Skeleton -> just send flag 
//////////////////////////////////////////////////////////////////////////////////

//         input1(16b),input2(16b),Flag(16b)
module Lt(X          ,Y          ,Z);
    //inputs 
    input [15:0] X,Y;
    //ouputs
    output [15:0] Z;
    wire TmpLt, nEq, TmpZ;
    wire [15:0] Zeq,ZLt;
    
    
    // 1. Set Less than flag: Check sign bit of 2's comp, 1==NEG,0==POS
    // a. If X is Less Than Y then X-Y == NEG
    //                                       input1(16b),input2(16b),CarryIn,CarryOut, Overflow  ,Output(16b)
    FullAdder2s_16bit       FA_Lt           (X          ,Y          ,1'b1    ,CoutLt     , OvLt        ,ZLt);    
    or(TmpLt,1'b0,ZLt[15]);
    // b. Account for if Eq is true for Lt and Gt
    // if XOR'd num == 0 -> Equal, else not eq
    xor XOR1 [15:0] (Zeq,X,Y);
    // Check if number is not zero, if so they are not equal
    or(nEq,Zeq[0],Zeq[1],Zeq[2],Zeq[3],Zeq[4],Zeq[5],Zeq[6],Zeq[7],Zeq[8],Zeq[9],Zeq[10],Zeq[11],Zeq[12],Zeq[13],Zeq[14],Zeq[15]);
    // c. 1 bit flag
    and(TmpZ,TmpLt,nEq);
    // d. 16 bit flag. 0 == FALSE, not zero == TRUE
    and AND_16flag[15:0] (Z,16'b0000_0000_0000_0001,TmpZ);
endmodule
