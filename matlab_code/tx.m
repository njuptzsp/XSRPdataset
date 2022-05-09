function [] = tx()

% 2 000 000 010
%% ��ʵ�����LTEЭ��
% LTE֡�ṹ 10ms����֡��1ms��֡��ÿ����֡������0.5msʱ϶����
% 1����֡14��OFDM���ţ�ÿ��ʱ϶7��OFDM���ţ���������ռ6*2�����ţ���Ƶ����ռ1*2������
% ��Ƶ����ռ�ݷ���λ��3��10����0��ʼ��0~13��
fftLen=2048;                %FFT����,Ĭ�϶�ֵ
subCarryNum=1200;           %���ز���Ŀ��Ĭ�϶�ֵ
ofdm_num=14;                %OFDM��������Ĭ�϶�ֵ

mod_type=2;                 %����ӳ�䷽ʽ��1:QPSK��2��16QAM
coder_type=1;               %�ŵ����뷽ʽ��1:1/2����룬2:1/3�����
snr = 20;                   %����ȣ�dB��
rf_switch=1;                %��Ƶ���أ�0��ʾ�ر���Ƶ���䣬1��ʾ������Ƶ����
pcip = '192.168.1.181';
xsrpip = '192.168.1.167';

%% ����ϵͳ���ŵ�����
% [bitLen] = OFDM_TxCalcSoltCap (subCarryNum,ofdm_num,coder_type,mod_type)
bitLen = 28792;
%% ���������Դ����
% [sourceBit] = OFDM_TxGenBitSource(bitLen);
% save('sourceBit.mat','sourceBit');
sourceBit_temp = load('sourceBit.mat');
sourceBit = sourceBit_temp.sourceBit;
%% �ŵ�����
[tch_data] = OFDM_TxTrchCoder(sourceBit, coder_type);

%% ����ӳ��
[mod_data] = OFDM_TxMod(tch_data,mod_type);%�����1*14400
a = reshape(mod_data,subCarryNum,12)';

% figure(1)
% plot(mod_data,'*')
% title('���Ͷ�����ͼ')

%% ����ʱ϶��Ƶ�źŲ���
% [rs_slot1,rs_local_slot1] = OFDM_pusch_rs_gen(100,0,0,4,0,0,0,0,3); %rs_slot1 ʱ϶1��Ƶ�ź� 1*1200
% [rs_slot2,rs_local_slot2] = OFDM_pusch_rs_gen(100,0,0,5,0,0,0,0,3); %rs_slot2 ʱ϶2��Ƶ�ź� 1*1200
% save('rs_slot.mat','rs_slot1','rs_slot2');
rs_slot = load('rs_slot.mat');
rs_slot1 = rs_slot.rs_slot1;
rs_slot2 = rs_slot.rs_slot2;
%% ��Դӳ��
remapdata = OFDM_remap(mod_data,rs_slot1,rs_slot2,100);%���14*1200

%% IFFT(Ƶ������תʱ��) 
[ifft_data] = OFDM_TxIFFT(remapdata);   %���� 14*1200,out 14*2048

%% ���CP
[add_cp_data] = OFDM_TxAddCP (ifft_data); %���룺14*2048�������1*30720
tx_data = add_cp_data;

%% ��Ƶ�������
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