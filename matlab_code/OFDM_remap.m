%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_remap.m
%  Description:         ������Դӳ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	��������ŵ����������� 
%       Input Parameter
%           moddata     ����ҵ������
%           rs_slot1    �ŵ�1 ��Ƶ����
%           rs_slot2    �ŵ�2 ��Ƶ����
%           rbnum       ��Դ�����              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2021-01-06
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   ����
% Remarks
%   ����ʱ϶��14��OFDM���ţ�1~7��8~14��λ��4��11�ֱ����ʱ϶1��ʱ϶2�ĵ�Ƶ�ź�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = OFDM_remap(moddata,rs_slot1,rs_slot2,rbnum)

temp = reshape(moddata,rbnum*12,12)'; %rbnum*12 һ����Դ��12�����ز�
temp = conj(temp);  % �����Ϊ��һ��reshape��������ת��
out = [temp(1:3,:);rs_slot1;temp(4:9,:);rs_slot2;temp(10:12,:)];

end


