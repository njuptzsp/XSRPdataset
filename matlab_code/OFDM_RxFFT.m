%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_RxFFT.m
%  Description:         ʱ��תƵ��OFDM�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           output_data     ���Ƶ�����ݣ�����ά��1*28672
%       Input Parameter
%           input_data      ����ʱ�����ݣ�����ά��14*2048
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output_data_s] = OFDM_RxFFT(input_data)
ofdm_num=14;
fft_num=2048;
output_data=zeros(ofdm_num,fft_num);%ȡ1ʱ϶������
for n=1:ofdm_num
    output_data(n,:)=fft(input_data(n,:));   %FFTʱ������תƵ��
end

output_data_s = (reshape(output_data',28672,1))';%����������תΪ�������ݣ�28672=14*2048
end
  