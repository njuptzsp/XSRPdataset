%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_TxCalcSlotCap.m
%  Description:         �ŵ���������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           bitLen	�ŵ��ɴ����bit���ݳ���
%       Input Parameter
%           subCarryNum  ���ز���
%           ofdm_num     OFDM����
%           code_type    �ŵ���������
%           mod_type     ���Ʒ�ʽ��1��QPSK��2��16QAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [bitLen] = OFDM_TxCalcSoltCap_zyb (subCarryNum,ofdm_num,coder_type,mod_type)

%bitNum:һ�����Ʒ��Ŷ�Ӧ���ٸ�bit
if mod_type ==1 %QPSK
    bitNum = 2; %2bit����һ�����Ʒ���
elseif mod_type ==2 %16QAM
    bitNum = 4;
elseif mod_type ==3 %64QAM
    bitNum = 6;
elseif mod_type ==4 %8PSK
    bitNum = 3;
end
     
if coder_type==1            %1/2���
    coder_len=2;
elseif coder_type==2        %1/3���
    coder_len=3;
else
    disp('������뷽ʽcoder_type,��֧��');
end
ofdm_num = ofdm_num-2;  %һ����֡��Ӧ����ʱ϶����14��OFDM���ţ�ÿ��ʱ϶�ĵ�Ƶ�ź�ռ1��OFDM����
bitLen=(subCarryNum*bitNum*ofdm_num)/coder_len-6;   %����ʱ϶�Ŀɴ��������bit����
        
end
  