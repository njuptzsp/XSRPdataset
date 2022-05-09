%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_RxFFT.m
%  Description:         时域转频域（OFDM解调）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           output_data     输出频域数据，数据维度1*28672
%       Input Parameter
%           input_data      输入时域数据，数据维度14*2048
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output_data_s] = OFDM_RxFFT(input_data)
ofdm_num=14;
fft_num=2048;
output_data=zeros(ofdm_num,fft_num);%取1时隙的数据
for n=1:ofdm_num
    output_data(n,:)=fft(input_data(n,:));   %FFT时域数据转频域
end

output_data_s = (reshape(output_data',28672,1))';%将并行数据转为串行数据，28672=14*2048
end
  