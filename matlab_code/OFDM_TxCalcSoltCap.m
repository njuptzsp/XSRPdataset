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
function [bitLen] = OFDM_TxCalcSoltCap (subCarryNum,ofdm_num,coder_type,mod_type)

bitNum=mod_type*2;          %һ�����Ʒ��Ŷ�Ӧ���ٸ�bit
if coder_type==1            %QPSK����
    coder_len=2;
elseif coder_type==2        %16QAM����
    coder_len=3;
else
    disp('������뷽ʽcoder_type,��֧��');
end
ofdm_num = ofdm_num-2;  %һ����֡��Ӧ����ʱ϶����14��OFDM���ţ�ÿ��ʱ϶�ĵ�Ƶ�ź�ռ1��OFDM����
bitLen=(subCarryNum*bitNum*ofdm_num)/coder_len-6;   %����ʱ϶�Ŀɴ��������bit����
        
end
  