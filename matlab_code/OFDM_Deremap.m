%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_Deremap.m
%  Description:         解资源映射
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           output_data     输出频域数据，数据维度14*1200
%       Input Parameter
%           input_data      输入时域数据，数据维度1*28672
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
    out(iii,start:total) = [fftout((nfft-half+1):nfft),fftout(1:half)]; % IFFT处理时填充的0，FFT处理后，把填充的0去掉，即[1:2048]取[ 1449:2048,1:600]
end