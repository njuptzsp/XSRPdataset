%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_TxIFFT.m
%  Description:         Ƶ��תʱ��OFDM���ƣ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           output_data     ���ʱ�����ݣ�����ά��14*2048
%       Input Parameter
%           input_data      ����Ƶ�����ݣ�����ά��14*1200
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output_data] = OFDM_TxIFFT(input_data)

ofdm_num=14;              %����ʱ϶��14��OFDM����
ifft_num=2048;            %IFFT������ֻ����2^n�����������ݵ���Ϊ1200��������2048������IFFT
output_data=zeros(ofdm_num,ifft_num);
fill_data=zeros(1,848);   %���ĵ�
for n=1:ofdm_num
    temp_data=[input_data(n,601:end),fill_data,input_data(n,1:600)];
    output_data(n,:)=ifft(temp_data,ifft_num);

end
  