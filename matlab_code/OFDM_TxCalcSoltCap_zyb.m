%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_TxCalcSlotCap.m
%  Description:         信道容量计算
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           bitLen	信道可传输的bit数据长度
%       Input Parameter
%           subCarryNum  子载波数
%           ofdm_num     OFDM符号
%           code_type    信道编码类型
%           mod_type     调制方式，1：QPSK，2：16QAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [bitLen] = OFDM_TxCalcSoltCap_zyb (subCarryNum,ofdm_num,coder_type,mod_type)

%bitNum:一个调制符号对应多少个bit
if mod_type ==1 %QPSK
    bitNum = 2; %2bit调制一个调制符号
elseif mod_type ==2 %16QAM
    bitNum = 4;
elseif mod_type ==3 %64QAM
    bitNum = 6;
elseif mod_type ==4 %8PSK
    bitNum = 3;
end
     
if coder_type==1            %1/2卷机
    coder_len=2;
elseif coder_type==2        %1/3卷积
    coder_len=3;
else
    disp('输入编码方式coder_type,不支持');
end
ofdm_num = ofdm_num-2;  %一个子帧对应两个时隙，共14个OFDM符号，每个时隙的导频信号占1个OFDM符号
bitLen=(subCarryNum*bitNum*ofdm_num)/coder_len-6;   %两个时隙的可传输的数据bit长度
        
end
  