
clear all
for i=1:1
    i


fftLen=2048;                
subCarryNum=1200;           
ofdm_num=14;                

mod_type=2;                 
coder_type=1;               
snr = 20;                 
rf_switch=1;                
pcip = '192.168.1.180';
xsrpip = '192.168.1.181';
[bitLen] = OFDM_TxCalcSoltCap_zyb(subCarryNum,ofdm_num,coder_type,mod_type);
[sourceBit] = OFDM_TxGenBitSource(bitLen);
[tch_data] = OFDM_TxTrchCoder(sourceBit, coder_type);
[mod_data] = OFDM_TxMod_zyb(tch_data,mod_type);
rs_slot = load('rs_slot.mat');
rs_slot1 = rs_slot.rs_slot1;
rs_slot2 = rs_slot.rs_slot2;
remapdata = OFDM_remap(mod_data,rs_slot1,rs_slot2,100);
[ifft_data] = OFDM_TxIFFT(remapdata);   
[add_cp_data] = OFDM_TxAddCP (ifft_data);
tx_data = add_cp_data;
if rf_switch==0
    rxData = tx_data;
else
    divFreq = 5;
    recv_len = 61440;
    type = 1;
    [rxdataIQ,message] = XSRP_RFLoopback(tx_data,divFreq,recv_len,pcip,xsrpip,type);
    rxData = rxdataIQ;
end
syn_data_temp = load('syn_data.mat');
syn_data = syn_data_temp.syn_data;
[ searchflag,timestart,cross_data,output ] = FindFrameHead( rxData,syn_data );
rxData = output;
if searchflag
    [deleteCP_data] = OFDM_RxDeleteCP(rxData);
    [FFT_data] = OFDM_RxFFT(deleteCP_data);
    freqdata = OFDM_Deremap(FFT_data);
    [slot0_lschannel,slot1_lschannel] = OFDM_lschannel(freqdata);  
    equfredata = OFDM_equal(freqdata,slot0_lschannel,slot1_lschannel,100);   
    [demod_data] = OFDM_RxDemod_zyb(equfredata,mod_type);
    [tch_decode_data] = OFDM_RxTrchDecoder(demod_data, coder_type);   
    errNum = sum(xor(tch_decode_data,sourceBit ));
else
    disp('Ö¡Í¬²½Ê§°Ü');
end

end