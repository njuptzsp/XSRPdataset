
clc
clear all
for i=1:1
    i
fftLen=2048;               
subCarryNum=1200;           
ofdm_num=14;               

mod_type=2;                 
coder_type=1;              
snr = 20;                  
rf_switch=0;                
pcip = '192.168.1.180';
xsrpip = '192.168.1.181';
bitLen = 28792;
rs_slot = load('rs_slot.mat');
rs_slot1 = rs_slot.rs_slot1;
rs_slot2 = rs_slot.rs_slot2;
divFreq = 5;
recv_len = 30720; 
type = 3;
tx_data = 0;
[rxdataIQ,message] = XSRP_RFLoopback(tx_data,divFreq,recv_len,pcip,xsrpip,type);
rxData = rxdataIQ;
figure(2)
plot(real(rxData)),title('接收信号')
syn_data_temp = load('syn_data.mat');
syn_data = syn_data_temp.syn_data;
figure(4)
plot(real(rxData)),title('接收信号')
[ searchflag,timestart,corrdata,output ] = FindFrameHead( rxData,syn_data );
figure(1)
plot(corrdata);
rxData = output;
if searchflag
    [deleteCP_data] = OFDM_RxDeleteCP(rxData); 
    [FFT_data] = OFDM_RxFFT(deleteCP_data);
    freqdata = OFDM_Deremap(FFT_data);
    [slot0_lschannel,slot1_lschannel] = OFDM_lschannel(freqdata);
    equfredata = OFDM_equal(freqdata,slot0_lschannel,slot1_lschannel,100);  
    figure(3)
    plot(equfredata,'*');
    title('接收端IQ星座图');
    [demod_data] = OFDM_RxDemod(equfredata,mod_type);
    [tch_decode_data] = OFDM_RxTrchDecoder(demod_data, coder_type);
    sourceBit_temp = load('sourceBit.mat');
    sourceBit = sourceBit_temp.sourceBit;
    sourceBit = [sourceBit,0,1];
    errNum = sum(xor(tch_decode_data,sourceBit ));
else
    disp('帧同步失败');
end

end