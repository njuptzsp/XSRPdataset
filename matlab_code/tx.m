function [] = tx()

% 2 000 000 010
%% 本实验参照LTE协议
% LTE帧结构 10ms无线帧，1ms子帧，每个子帧由两个0.5ms时隙构成
% 1个子帧14个OFDM符号，每个时隙7个OFDM符号，有用数据占6*2个符号，导频数据占1*2个符号
% 导频数据占据符号位置3、10（从0开始，0~13）
fftLen=2048;                %FFT点数,默认定值
subCarryNum=1200;           %子载波数目，默认定值
ofdm_num=14;                %OFDM符号数，默认定值

mod_type=2;                 %调制映射方式，1:QPSK，2：16QAM
coder_type=1;               %信道编码方式，1:1/2卷积码，2:1/3卷积码
snr = 20;                   %信噪比（dB）
rf_switch=1;                %射频开关，0表示关闭射频发射，1表示开启射频发射
pcip = '192.168.1.181';
xsrpip = '192.168.1.167';

%% 计算系统的信道容量
% [bitLen] = OFDM_TxCalcSoltCap (subCarryNum,ofdm_num,coder_type,mod_type)
bitLen = 28792;
%% 生成随机信源比特
% [sourceBit] = OFDM_TxGenBitSource(bitLen);
% save('sourceBit.mat','sourceBit');
sourceBit_temp = load('sourceBit.mat');
sourceBit = sourceBit_temp.sourceBit;
%% 信道编码
[tch_data] = OFDM_TxTrchCoder(sourceBit, coder_type);

%% 调制映射
[mod_data] = OFDM_TxMod(tch_data,mod_type);%输出：1*14400
a = reshape(mod_data,subCarryNum,12)';

% figure(1)
% plot(mod_data,'*')
% title('发送端星座图')

%% 两个时隙导频信号产生
% [rs_slot1,rs_local_slot1] = OFDM_pusch_rs_gen(100,0,0,4,0,0,0,0,3); %rs_slot1 时隙1导频信号 1*1200
% [rs_slot2,rs_local_slot2] = OFDM_pusch_rs_gen(100,0,0,5,0,0,0,0,3); %rs_slot2 时隙2导频信号 1*1200
% save('rs_slot.mat','rs_slot1','rs_slot2');
rs_slot = load('rs_slot.mat');
rs_slot1 = rs_slot.rs_slot1;
rs_slot2 = rs_slot.rs_slot2;
%% 资源映射
remapdata = OFDM_remap(mod_data,rs_slot1,rs_slot2,100);%输出14*1200

%% IFFT(频域数据转时域) 
[ifft_data] = OFDM_TxIFFT(remapdata);   %输入 14*1200,out 14*2048

%% 添加CP
[add_cp_data] = OFDM_TxAddCP (ifft_data); %输入：14*2048，输出：1*30720
tx_data = add_cp_data;

%% 射频发射接收
if rf_switch==0
    rxData = awgn(tx_data,snr,'measured');
%     rxData = tx_data;
else
%     [rxData] = OFDM_RFLoopback(tx_data,pcip,xsrpip);
    divFreq = 1;
    recv_len = 61440;
    type = 1;
    [rxdataIQ,message] = XSRP_RFLoopback(tx_data,divFreq,recv_len,pcip,xsrpip,type);
    rxData = rxdataIQ;
end