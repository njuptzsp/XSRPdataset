%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_TxIFFT.m
%  Description:         频域转时域（OFDM调制）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           output_data     输出时域数据，数据维度14*2048
%       Input Parameter
%           input_data      输入频域数据，数据维度14*1200
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output_data] = OFDM_TxIFFT(input_data)

ofdm_num=14;              %两个时隙，14个OFDM符号
ifft_num=2048;            %IFFT点数，只能是2^n个点由于数据点数为1200个点所以2048个点做IFFT
output_data=zeros(ofdm_num,ifft_num);
fill_data=zeros(1,848);   %填充的点
for n=1:ofdm_num
    temp_data=[input_data(n,601:end),fill_data,input_data(n,1:600)];
    output_data(n,:)=ifft(temp_data,ifft_num);

end
  