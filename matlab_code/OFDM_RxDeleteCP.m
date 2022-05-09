%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_RxDeleteCP.m
%  Description:         去CP（循环前缀）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           output_data     输出数据，数据维度14*2048
%       Input Parameter
%           data            输入待去CP数据，数据维度1*30720
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output_data] = OFDM_RxDeleteCP(data)

ofdm_num = 14;
fft_size = 2048;
cp1 =160;
cp2 =144;
output_data = zeros(ofdm_num,fft_size);
start = 1;

for n=1:ofdm_num
    if mod(n+6,7) == 0  % 第1和第8个OFDM符号，前面加的CP长度是160
        output_data(n,:) = data(1,start+cp1:start+cp1+  fft_size-1);
        start = start+cp1+fft_size;
    else                % 其余OFDM符号，前面加的CP长度是144
        output_data(n,:) = data(1,start+cp2 : start+cp2+fft_size-1);
        start = start+cp2+fft_size;
    end
end

end
  