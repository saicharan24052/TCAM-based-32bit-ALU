module mux2 (
    input  A,    // input A
    input  B,    // input B
    input  S,    // select signal
    input clk,
    output  Y     // output Y, declared as reg type
);
reg Z;
always @(posedge clk)  begin
    case (S)
        1'b0: Z = A;
        1'b1: Z = B;
        default: Z = A; // default case, in case S is undefined
    endcase
end
assign Y = Z;
endmodule

module Left_32 (in, ctrl,clk, out);
input  [31:0] in;
input [4:0] ctrl;
input clk;
output [31:0] out;
wire [31:0] x,y,z,m;

mux2 mux_31(in[0], 1'b0, ctrl[4],clk, x[0]);
mux2 mux_30(in[1], 1'b0, ctrl[4],clk, x[1]);
mux2 mux_29(in[2], 1'b0, ctrl[4],clk, x[2]);
mux2 mux_28(in[3], 1'b0, ctrl[4],clk, x[3]);
mux2 mux_27(in[4], 1'b0, ctrl[4],clk, x[4]);
mux2 mux_26(in[5], 1'b0, ctrl[4],clk, x[5]);
mux2 mux_25(in[6], 1'b0, ctrl[4],clk, x[6]);
mux2 mux_24(in[7], 1'b0, ctrl[4],clk, x[7]);
mux2 mux_23(in[8], 1'b0, ctrl[4],clk, x[8]);
mux2 mux_22(in[9], 1'b0, ctrl[4],clk, x[9]);
mux2 mux_21(in[10], 1'b0, ctrl[4],clk, x[10]);
mux2 mux_20(in[11], 1'b0, ctrl[4],clk, x[11]);
mux2 mux_19(in[12], 1'b0, ctrl[4],clk, x[12]);
mux2 mux_18(in[13], 1'b0, ctrl[4],clk, x[13]);
mux2 mux_17(in[14], 1'b0, ctrl[4],clk, x[14]);
mux2 mux_16(in[15], 1'b0, ctrl[4],clk, x[15]);
mux2 mux_15(in[16], in[0], ctrl[4],clk, x[16]);
mux2 mux_14(in[17], in[1], ctrl[4],clk, x[17]);
mux2 mux_13(in[18], in[2], ctrl[4],clk, x[18]);
mux2 mux_12(in[19], in[3], ctrl[4],clk, x[19]);
mux2 mux_11(in[20], in[4], ctrl[4],clk, x[20]);
mux2 mux_10(in[21], in[5], ctrl[4],clk, x[21]);
mux2 mux_9(in[22], in[6], ctrl[4],clk, x[22]);
mux2 mux_8(in[23], in[7], ctrl[4],clk, x[23]);
mux2 mux_7(in[24], in[8], ctrl[4],clk, x[24]);
mux2 mux_6(in[25], in[9], ctrl[4],clk, x[25]);
mux2 mux_5(in[26], in[10], ctrl[4],clk, x[26]);
mux2 mux_4(in[27], in[11], ctrl[4],clk, x[27]);
mux2 mux_3(in[28], in[12], ctrl[4],clk, x[28]);
mux2 mux_2(in[29], in[13], ctrl[4],clk, x[29]);
mux2 mux_1(in[30], in[14], ctrl[4],clk, x[30]);
mux2 mux_0(in[31], in[15], ctrl[4],clk, x[31]);



mux2 mux_63(x[0], 1'b0, ctrl[3],clk, y[0]);
mux2 mux_62(x[1], 1'b0, ctrl[3],clk, y[1]);
mux2 mux_61(x[2], 1'b0, ctrl[3],clk, y[2]);
mux2 mux_60(x[3], 1'b0, ctrl[3],clk, y[3]);
mux2 mux_59(x[4], 1'b0, ctrl[3],clk, y[4]);
mux2 mux_58(x[5], 1'b0, ctrl[3],clk, y[5]);
mux2 mux_57(x[6], 1'b0, ctrl[3],clk, y[6]);
mux2 mux_56(x[7], 1'b0, ctrl[3],clk, y[7]);
mux2 mux_55(x[8], x[0], ctrl[3],clk, y[8]);
mux2 mux_54(x[9], x[1], ctrl[3],clk, y[9]);
mux2 mux_53(x[10], x[2], ctrl[3],clk, y[10]);
mux2 mux_52(x[11], x[3], ctrl[3],clk, y[11]);
mux2 mux_51(x[12], x[4], ctrl[3],clk, y[12]);
mux2 mux_50(x[13], x[5], ctrl[3],clk, y[13]);
mux2 mux_49(x[14], x[6], ctrl[3],clk, y[14]);
mux2 mux_48(x[15], x[7], ctrl[3],clk, y[15]);
mux2 mux_47(x[16], x[8], ctrl[3],clk, y[16]);
mux2 mux_46(x[17], x[9], ctrl[3],clk, y[17]);
mux2 mux_45(x[18], x[10], ctrl[3],clk, y[18]);
mux2 mux_44(x[19], x[11], ctrl[3],clk, y[19]);
mux2 mux_43(x[20], x[12], ctrl[3],clk, y[20]);
mux2 mux_42(x[21], x[13], ctrl[3],clk, y[21]);
mux2 mux_41(x[22], x[14], ctrl[3],clk, y[22]);
mux2 mux_40(x[23], x[15], ctrl[3],clk, y[23]);
mux2 mux_39(x[24], x[16], ctrl[3],clk, y[24]);
mux2 mux_38(x[25], x[17], ctrl[3],clk, y[25]);
mux2 mux_37(x[26], x[18], ctrl[3],clk, y[26]);
mux2 mux_36(x[27], x[19], ctrl[3],clk, y[27]);
mux2 mux_35(x[28], x[20], ctrl[3],clk, y[28]);
mux2 mux_34(x[29], x[21], ctrl[3],clk, y[29]);
mux2 mux_33(x[30], x[22], ctrl[3],clk, y[30]);
mux2 mux_32(x[31], x[23], ctrl[3],clk, y[31]);



mux2 mux_95(y[0], 1'b0, ctrl[2],clk, z[0]);
mux2 mux_94(y[1], 1'b0, ctrl[2],clk, z[1]);
mux2 mux_93(y[2], 1'b0, ctrl[2],clk, z[2]);
mux2 mux_92(y[3], 1'b0, ctrl[2],clk, z[3]);
mux2 mux_91(y[4], y[0], ctrl[2],clk, z[4]);
mux2 mux_90(y[5], y[1], ctrl[2],clk, z[5]);
mux2 mux_89(y[6], y[2], ctrl[2],clk, z[6]);
mux2 mux_88(y[7], y[3], ctrl[2],clk, z[7]);
mux2 mux_87(y[8], y[4], ctrl[2],clk, z[8]);
mux2 mux_86(y[9], y[5], ctrl[2],clk, z[9]);
mux2 mux_85(y[10], y[6], ctrl[2],clk, z[10]);
mux2 mux_84(y[11], y[7], ctrl[2],clk, z[11]);
mux2 mux_83(y[12], y[8], ctrl[2],clk, z[12]);
mux2 mux_82(y[13], y[9], ctrl[2],clk, z[13]);
mux2 mux_81(y[14], y[10], ctrl[2],clk, z[14]);
mux2 mux_80(y[15], y[11], ctrl[2],clk, z[15]);
mux2 mux_79(y[16], y[12], ctrl[2],clk, z[16]);
mux2 mux_78(y[17], y[13], ctrl[2],clk, z[17]);
mux2 mux_77(y[18], y[14], ctrl[2],clk, z[18]);
mux2 mux_76(y[19], y[15], ctrl[2],clk, z[19]);
mux2 mux_75(y[20], y[16], ctrl[2],clk, z[20]);
mux2 mux_74(y[21], y[17], ctrl[2],clk, z[21]);
mux2 mux_73(y[22], y[18], ctrl[2],clk, z[22]);
mux2 mux_72(y[23], y[19], ctrl[2],clk, z[23]);
mux2 mux_71(y[24], y[20], ctrl[2],clk, z[24]);
mux2 mux_70(y[25], y[21], ctrl[2],clk, z[25]);
mux2 mux_69(y[26], y[22], ctrl[2],clk, z[26]);
mux2 mux_68(y[27], y[23], ctrl[2],clk, z[27]);
mux2 mux_67(y[28], y[24], ctrl[2],clk, z[28]);
mux2 mux_66(y[29], y[25], ctrl[2],clk, z[29]);
mux2 mux_65(y[30], y[26], ctrl[2],clk, z[30]);
mux2 mux_64(y[31], y[27], ctrl[2],clk, z[31]);



mux2 mux_127(z[0], 1'b0, ctrl[1],clk, m[0]);
mux2 mux_126(z[1], 1'b0, ctrl[1],clk, m[1]);
mux2 mux_125(z[2], z[0], ctrl[1],clk, m[2]);
mux2 mux_124(z[3], z[1], ctrl[1],clk, m[3]);
mux2 mux_123(z[4], z[2], ctrl[1],clk, m[4]);
mux2 mux_122(z[5], z[3], ctrl[1],clk, m[5]);
mux2 mux_121(z[6], z[4], ctrl[1],clk, m[6]);
mux2 mux_120(z[7], z[5], ctrl[1],clk, m[7]);
mux2 mux_119(z[8], z[6], ctrl[1],clk, m[8]);
mux2 mux_118(z[9], z[7], ctrl[1],clk, m[9]);
mux2 mux_117(z[10], z[8], ctrl[1],clk, m[10]);
mux2 mux_116(z[11], z[9], ctrl[1],clk, m[11]);
mux2 mux_115(z[12], z[10], ctrl[1],clk, m[12]);
mux2 mux_114(z[13], z[11], ctrl[1],clk, m[13]);
mux2 mux_113(z[14], z[12], ctrl[1],clk, m[14]);
mux2 mux_112(z[15], z[13], ctrl[1],clk, m[15]);
mux2 mux_111(z[16], z[14], ctrl[1],clk, m[16]);
mux2 mux_110(z[17], z[15], ctrl[1],clk, m[17]);
mux2 mux_109(z[18], z[16], ctrl[1],clk, m[18]);
mux2 mux_108(z[19], z[17], ctrl[1],clk, m[19]);
mux2 mux_107(z[20], z[18], ctrl[1],clk, m[20]);
mux2 mux_106(z[21], z[19], ctrl[1],clk, m[21]);
mux2 mux_105(z[22], z[20], ctrl[1],clk, m[22]);
mux2 mux_104(z[23], z[21], ctrl[1],clk, m[23]);
mux2 mux_103(z[24], z[22], ctrl[1],clk, m[24]);
mux2 mux_102(z[25], z[23], ctrl[1],clk, m[25]);
mux2 mux_101(z[26], z[24], ctrl[1],clk, m[26]);
mux2 mux_100(z[27], z[25], ctrl[1],clk, m[27]);
mux2 mux_99(z[28], z[26], ctrl[1],clk, m[28]);
mux2 mux_98(z[29], z[27], ctrl[1],clk, m[29]);
mux2 mux_97(z[30], z[28], ctrl[1],clk, m[30]);
mux2 mux_96(z[31], z[29], ctrl[1],clk, m[31]);



mux2 mux_159(m[0], 1'b0, ctrl[0],clk, out[0]);
mux2 mux_158(m[1], m[0], ctrl[0],clk, out[1]);
mux2 mux_157(m[2], m[1], ctrl[0],clk, out[2]);
mux2 mux_156(m[3], m[2], ctrl[0],clk, out[3]);
mux2 mux_155(m[4], m[3], ctrl[0],clk, out[4]);
mux2 mux_154(m[5], m[4], ctrl[0],clk, out[5]);
mux2 mux_153(m[6], m[5], ctrl[0],clk, out[6]);
mux2 mux_152(m[7], m[6], ctrl[0],clk, out[7]);
mux2 mux_151(m[8], m[7], ctrl[0],clk, out[8]);
mux2 mux_150(m[9], m[8], ctrl[0],clk, out[9]);
mux2 mux_149(m[10], m[9], ctrl[0],clk, out[10]);
mux2 mux_148(m[11], m[10], ctrl[0],clk, out[11]);
mux2 mux_147(m[12], m[11], ctrl[0],clk, out[12]);
mux2 mux_146(m[13], m[12], ctrl[0],clk, out[13]);
mux2 mux_145(m[14], m[13], ctrl[0],clk, out[14]);
mux2 mux_144(m[15], m[14], ctrl[0],clk, out[15]);
mux2 mux_143(m[16], m[15], ctrl[0],clk, out[16]);
mux2 mux_142(m[17], m[16], ctrl[0],clk, out[17]);
mux2 mux_141(m[18], m[17], ctrl[0],clk, out[18]);
mux2 mux_140(m[19], m[18], ctrl[0],clk, out[19]);
mux2 mux_139(m[20], m[19], ctrl[0],clk, out[20]);
mux2 mux_138(m[21], m[20], ctrl[0],clk, out[21]);
mux2 mux_137(m[22], m[21], ctrl[0],clk, out[22]);
mux2 mux_136(m[23], m[22], ctrl[0],clk, out[23]);
mux2 mux_135(m[24], m[23], ctrl[0],clk, out[24]);
mux2 mux_134(m[25], m[24], ctrl[0],clk, out[25]);
mux2 mux_133(m[26], m[25], ctrl[0],clk, out[26]);
mux2 mux_132(m[27], m[26], ctrl[0],clk, out[27]);
mux2 mux_131(m[28], m[27], ctrl[0],clk, out[28]);
mux2 mux_130(m[29], m[28], ctrl[0],clk, out[29]);
mux2 mux_129(m[30], m[29], ctrl[0],clk, out[30]);
mux2 mux_128(m[31], m[30], ctrl[0],clk, out[31]);
endmodule
