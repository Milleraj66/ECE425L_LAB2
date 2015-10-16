`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// AUTHOR: ARTHUR J. MILLER & Bibek B.
// Module Name: BNE
// Create Date: 10/15/2015 08:42:54 PM
// ECE425L LAB #2
// Purpose: Branch if Not Equal Operation
//          Skeleton -> just send flag 
//////////////////////////////////////////////////////////////////////////////////

//         input1(16b),input2(16b),Flag(16b)
module BNE(X          ,Y          ,Z);
    //inputs 
    input [15:0] X,Y;
    //ouputs
    output [15:0] Z;
    
    // LOGIC for checking if numbers equal
    // c. Set Equal to flag: 
    // if XOR'd num == 0 -> Equal, else not eq
    // since ouput is 16bit just send the xor'd number
    // if zero ouput is zero[FALSE], else ouput is not one[TRUE]
    xor XOR1 [15:0] (Z,X,Y);
    // Check if number is not zero, if so they are not equal -> flag = 1
    //or(Z,Zeq[0],Zeq[1],Zeq[2],Zeq[3],Zeq[4],Zeq[5],Zeq[6],Zeq[7],Zeq[8],Zeq[9],Zeq[10],Zeq[11],Zeq[12],Zeq[13],Zeq[14],Zeq[15]);
endmodule
