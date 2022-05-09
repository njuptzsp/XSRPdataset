function [output_data] = OFDM_TxAddSyncCode (input_data,sc_data)
ofdm_num=14;
FFT_num=2048;

output_data=zeros(1,ofdm_num*FFT_num);

sync_len=length(sc_data);
input_data(1,1:sync_len)=sc_data;

output_data=[input_data,input_data];%将时隙1复制到时隙2，即一个子帧数据

end