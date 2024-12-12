module mux2 (
    input  A,    // input A
    input  B,    // input B
    input  S,    // select signal
    output  Y     // output Y, declared as reg type
);
reg Z;
always @(*)  begin
    case (S)
        1'b0: Z = A;
        1'b1: Z = B;
        default: Z = A; // default case, in case S is undefined
    endcase
end
assign Y = Z;
endmodule

module Right_32 (in, ctrl, out);
input  [31:0] in;
input [4:0] ctrl;
output [31:0] out;
wire [31:0] x,y,z,m;



mux2 mux_31(in[31], 1'b0, ctrl[4], x[31]);
mux2 mux_30(in[30], 1'b0, ctrl[4], x[30]);
mux2 mux_29(in[29], 1'b0, ctrl[4], x[29]);
mux2 mux_28(in[28], 1'b0, ctrl[4], x[28]);
mux2 mux_27(in[27], 1'b0, ctrl[4], x[27]);
mux2 mux_26(in[26], 1'b0, ctrl[4], x[26]);
mux2 mux_25(in[25], 1'b0, ctrl[4], x[25]);
mux2 mux_24(in[24], 1'b0, ctrl[4], x[24]);
mux2 mux_23(in[23], 1'b0, ctrl[4], x[23]);
mux2 mux_22(in[22], 1'b0, ctrl[4], x[22]);
mux2 mux_21(in[21], 1'b0, ctrl[4], x[21]);
mux2 mux_20(in[20], 1'b0, ctrl[4], x[20]);
mux2 mux_19(in[19], 1'b0, ctrl[4], x[19]);
mux2 mux_18(in[18], 1'b0, ctrl[4], x[18]);
mux2 mux_17(in[17], 1'b0, ctrl[4], x[17]);
mux2 mux_16(in[16], 1'b0, ctrl[4], x[16]);
mux2 mux_15(in[15], in[31], ctrl[4], x[15]);
mux2 mux_14(in[14], in[30], ctrl[4], x[14]);
mux2 mux_13(in[13], in[29], ctrl[4], x[13]);
mux2 mux_12(in[12], in[28], ctrl[4], x[12]);
mux2 mux_11(in[11], in[27], ctrl[4], x[11]);
mux2 mux_10(in[10], in[26], ctrl[4], x[10]);
mux2 mux_9(in[9], in[25], ctrl[4], x[9]);
mux2 mux_8(in[8], in[24], ctrl[4], x[8]);
mux2 mux_7(in[7], in[23], ctrl[4], x[7]);
mux2 mux_6(in[6], in[22], ctrl[4], x[6]);
mux2 mux_5(in[5], in[21], ctrl[4], x[5]);
mux2 mux_4(in[4], in[20], ctrl[4], x[4]);
mux2 mux_3(in[3], in[19], ctrl[4], x[3]);
mux2 mux_2(in[2], in[18], ctrl[4], x[2]);
mux2 mux_1(in[1], in[17], ctrl[4], x[1]);
mux2 mux_0(in[0], in[16], ctrl[4], x[0]);



mux2 mux_63(x[31], 1'b0, ctrl[3], y[31]);
mux2 mux_62(x[30], 1'b0, ctrl[3], y[30]);
mux2 mux_61(x[29], 1'b0, ctrl[3], y[29]);
mux2 mux_60(x[28], 1'b0, ctrl[3], y[28]);
mux2 mux_59(x[27], 1'b0, ctrl[3], y[27]);
mux2 mux_58(x[26], 1'b0, ctrl[3], y[26]);
mux2 mux_57(x[25], 1'b0, ctrl[3], y[25]);
mux2 mux_56(x[24], 1'b0, ctrl[3], y[24]);
mux2 mux_55(x[23], x[31], ctrl[3], y[23]);
mux2 mux_54(x[22], x[30], ctrl[3], y[22]);
mux2 mux_53(x[21], x[29], ctrl[3], y[21]);
mux2 mux_52(x[20], x[28], ctrl[3], y[20]);
mux2 mux_51(x[19], x[27], ctrl[3], y[19]);
mux2 mux_50(x[18], x[26], ctrl[3], y[18]);
mux2 mux_49(x[17], x[25], ctrl[3], y[17]);
mux2 mux_48(x[16], x[24], ctrl[3], y[16]);
mux2 mux_47(x[15], x[23], ctrl[3], y[15]);
mux2 mux_46(x[14], x[22], ctrl[3], y[14]);
mux2 mux_45(x[13], x[21], ctrl[3], y[13]);
mux2 mux_44(x[12], x[20], ctrl[3], y[12]);
mux2 mux_43(x[11], x[19], ctrl[3], y[11]);
mux2 mux_42(x[10], x[18], ctrl[3], y[10]);
mux2 mux_41(x[9], x[17], ctrl[3], y[9]);
mux2 mux_40(x[8], x[16], ctrl[3], y[8]);
mux2 mux_39(x[7], x[15], ctrl[3], y[7]);
mux2 mux_38(x[6], x[14], ctrl[3], y[6]);
mux2 mux_37(x[5], x[13], ctrl[3], y[5]);
mux2 mux_36(x[4], x[12], ctrl[3], y[4]);
mux2 mux_35(x[3], x[11], ctrl[3], y[3]);
mux2 mux_34(x[2], x[10], ctrl[3], y[2]);
mux2 mux_33(x[1], x[9], ctrl[3], y[1]);
mux2 mux_32(x[0], x[8], ctrl[3], y[0]);



mux2 mux_95(y[31], 1'b0, ctrl[2], z[31]);
mux2 mux_94(y[30], 1'b0, ctrl[2], z[30]);
mux2 mux_93(y[29], 1'b0, ctrl[2], z[29]);
mux2 mux_92(y[28], 1'b0, ctrl[2], z[28]);
mux2 mux_91(y[27], y[31], ctrl[2], z[27]);
mux2 mux_90(y[26], y[30], ctrl[2], z[26]);
mux2 mux_89(y[25], y[29], ctrl[2], z[25]);
mux2 mux_88(y[24], y[28], ctrl[2], z[24]);
mux2 mux_87(y[23], y[27], ctrl[2], z[23]);
mux2 mux_86(y[22], y[26], ctrl[2], z[22]);
mux2 mux_85(y[21], y[25], ctrl[2], z[21]);
mux2 mux_84(y[20], y[24], ctrl[2], z[20]);
mux2 mux_83(y[19], y[23], ctrl[2], z[19]);
mux2 mux_82(y[18], y[22], ctrl[2], z[18]);
mux2 mux_81(y[17], y[21], ctrl[2], z[17]);
mux2 mux_80(y[16], y[20], ctrl[2], z[16]);
mux2 mux_79(y[15], y[19], ctrl[2], z[15]);
mux2 mux_78(y[14], y[18], ctrl[2], z[14]);
mux2 mux_77(y[13], y[17], ctrl[2], z[13]);
mux2 mux_76(y[12], y[16], ctrl[2], z[12]);
mux2 mux_75(y[11], y[15], ctrl[2], z[11]);
mux2 mux_74(y[10], y[14], ctrl[2], z[10]);
mux2 mux_73(y[9], y[13], ctrl[2], z[9]);
mux2 mux_72(y[8], y[12], ctrl[2], z[8]);
mux2 mux_71(y[7], y[11], ctrl[2], z[7]);
mux2 mux_70(y[6], y[10], ctrl[2], z[6]);
mux2 mux_69(y[5], y[9], ctrl[2], z[5]);
mux2 mux_68(y[4], y[8], ctrl[2], z[4]);
mux2 mux_67(y[3], y[7], ctrl[2], z[3]);
mux2 mux_66(y[2], y[6], ctrl[2], z[2]);
mux2 mux_65(y[1], y[5], ctrl[2], z[1]);
mux2 mux_64(y[0], y[4], ctrl[2], z[0]);



mux2 mux_127(z[31], 1'b0, ctrl[1], m[31]);
mux2 mux_126(z[30], 1'b0, ctrl[1], m[30]);
mux2 mux_125(z[29], z[31], ctrl[1], m[29]);
mux2 mux_124(z[28], z[30], ctrl[1], m[28]);
mux2 mux_123(z[27], z[29], ctrl[1], m[27]);
mux2 mux_122(z[26], z[28], ctrl[1], m[26]);
mux2 mux_121(z[25], z[27], ctrl[1], m[25]);
mux2 mux_120(z[24], z[26], ctrl[1], m[24]);
mux2 mux_119(z[23], z[25], ctrl[1], m[23]);
mux2 mux_118(z[22], z[24], ctrl[1], m[22]);
mux2 mux_117(z[21], z[23], ctrl[1], m[21]);
mux2 mux_116(z[20], z[22], ctrl[1], m[20]);
mux2 mux_115(z[19], z[21], ctrl[1], m[19]);
mux2 mux_114(z[18], z[20], ctrl[1], m[18]);
mux2 mux_113(z[17], z[19], ctrl[1], m[17]);
mux2 mux_112(z[16], z[18], ctrl[1], m[16]);
mux2 mux_111(z[15], z[17], ctrl[1], m[15]);
mux2 mux_110(z[14], z[16], ctrl[1], m[14]);
mux2 mux_109(z[13], z[15], ctrl[1], m[13]);
mux2 mux_108(z[12], z[14], ctrl[1], m[12]);
mux2 mux_107(z[11], z[13], ctrl[1], m[11]);
mux2 mux_106(z[10], z[12], ctrl[1], m[10]);
mux2 mux_105(z[9], z[11], ctrl[1], m[9]);
mux2 mux_104(z[8], z[10], ctrl[1], m[8]);
mux2 mux_103(z[7], z[9], ctrl[1], m[7]);
mux2 mux_102(z[6], z[8], ctrl[1], m[6]);
mux2 mux_101(z[5], z[7], ctrl[1], m[5]);
mux2 mux_100(z[4], z[6], ctrl[1], m[4]);
mux2 mux_99(z[3], z[5], ctrl[1], m[3]);
mux2 mux_98(z[2], z[4], ctrl[1], m[2]);
mux2 mux_97(z[1], z[3], ctrl[1], m[1]);
mux2 mux_96(z[0], z[2], ctrl[1], m[0]);



mux2 mux_159(m[31], 1'b0, ctrl[0], out[31]);
mux2 mux_158(m[30], m[31], ctrl[0], out[30]);
mux2 mux_157(m[29], m[30], ctrl[0], out[29]);
mux2 mux_156(m[28], m[29], ctrl[0], out[28]);
mux2 mux_155(m[27], m[28], ctrl[0], out[27]);
mux2 mux_154(m[26], m[27], ctrl[0], out[26]);
mux2 mux_153(m[25], m[26], ctrl[0], out[25]);
mux2 mux_152(m[24], m[25], ctrl[0], out[24]);
mux2 mux_151(m[23], m[24], ctrl[0], out[23]);
mux2 mux_150(m[22], m[23], ctrl[0], out[22]);
mux2 mux_149(m[21], m[22], ctrl[0], out[21]);
mux2 mux_148(m[20], m[21], ctrl[0], out[20]);
mux2 mux_147(m[19], m[20], ctrl[0], out[19]);
mux2 mux_146(m[18], m[19], ctrl[0], out[18]);
mux2 mux_145(m[17], m[18], ctrl[0], out[17]);
mux2 mux_144(m[16], m[17], ctrl[0], out[16]);
mux2 mux_143(m[15], m[16], ctrl[0], out[15]);
mux2 mux_142(m[14], m[15], ctrl[0], out[14]);
mux2 mux_141(m[13], m[14], ctrl[0], out[13]);
mux2 mux_140(m[12], m[13], ctrl[0], out[12]);
mux2 mux_139(m[11], m[12], ctrl[0], out[11]);
mux2 mux_138(m[10], m[11], ctrl[0], out[10]);
mux2 mux_137(m[9], m[10], ctrl[0], out[9]);
mux2 mux_136(m[8], m[9], ctrl[0], out[8]);
mux2 mux_135(m[7], m[8], ctrl[0], out[7]);
mux2 mux_134(m[6], m[7], ctrl[0], out[6]);
mux2 mux_133(m[5], m[6], ctrl[0], out[5]);
mux2 mux_132(m[4], m[5], ctrl[0], out[4]);
mux2 mux_131(m[3], m[4], ctrl[0], out[3]);
mux2 mux_130(m[2], m[3], ctrl[0], out[2]);
mux2 mux_129(m[1], m[2], ctrl[0], out[1]);
mux2 mux_128(m[0], m[1], ctrl[0], out[0]); 
endmodule
