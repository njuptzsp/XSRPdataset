%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_TxMod.m
%  Description:         调制映射
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           output_data     调制映射后数据
%       Input Parameter
%           input_data      待调制比特数据
%           mod_type        调制方式，1：QPSK，2：16QAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output_data] = OFDM_TxMod(input_data,mod_type)
bit_symbol=mod_type*2;  %一个调制符号对应比特数
[num,bit_len]=size(input_data);
output_data=zeros(1,floor(bit_len/bit_symbol));%初始化调制映射数据

if mod_type==1  %QPSK调制，（1，0）调制映射为（-1，1）
    temp = 1/(2^0.5); %功率归一化因子
    data_real=1-2*input_data(1,1:2:end);
    data_imag=1-2*input_data(1,2:2:end);
    output_data(1,:)=(data_real+data_imag*i)/temp;%
elseif mod_type==2; %16QAM调制，
    temp = 1/(10^0.5);%功率归一化因子
    QAM16_table = temp*[(1+1i), (1+3j), (3+1i), (3+3j), (1-1i), (1-3j), (3-1i), (3-3j), ...
                    (-1+1i),(-1+3j),(-3+1i),(-3+3j),(-1-1i),(-1-3j),(-3-1i),(-3-3j)]; %16QAM调制映射表
    for n=1:floor(bit_len/bit_symbol)
        output_data(1,n)=QAM16_table( input_data(1,(n-1)*4+1)*8+input_data(1,(n-1)*4+2)*4+input_data(1,(n-1)*4+3)*2+input_data(1,(n-1)*4+4)*1+1 );%根据映射表索引进行对应
    end
else
    disp('不支持调制模式');
end

end
  