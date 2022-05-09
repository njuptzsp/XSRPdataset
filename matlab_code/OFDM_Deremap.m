%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_Deremap.m
%  Description:         ����Դӳ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           output_data     ���Ƶ�����ݣ�����ά��14*1200
%       Input Parameter
%           input_data      ����ʱ�����ݣ�����ά��1*28672
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = OFDM_Deremap(inputdata)
rbnul =100;
nfft =2048;
nulsym =7;
start =1;
half = rbnul*6;
total = rbnul*12;
for(iii=1:2*nulsym)
    fftout = inputdata((iii-1)*nfft+1:iii*nfft); 
    out(iii,start:total) = [fftout((nfft-half+1):nfft),fftout(1:half)]; % IFFT����ʱ����0��FFT����󣬰�����0ȥ������[1:2048]ȡ[ 1449:2048,1:600]
end