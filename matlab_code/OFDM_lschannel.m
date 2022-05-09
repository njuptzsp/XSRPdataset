%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_lschannel.m
%  Description:         �ŵ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           slot0_ls	ʱ϶1���ƺ����ݣ�����ά��1*1200
%           slot1_ls	ʱ϶2���ƺ����ݣ�����ά��1*1200
%       Input Parameter
%           fredata     ������ŵ���������,����ά��14*1200             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   ����
% Remarks
%       ����Ƕ����һ��Ԥ�����źţ����Ϊ�ο��źŻ�Ƶ�źţ�
%       ����Щ�ο��ź�ͨ���ŵ�ʱ�������������ź�һ��ʧ�棨˥�������ƣ�������
%       �����ڽ��շ����/������յ��Ĳο��ź�
%       �ȽϷ��͵Ĳο��źźͽ��յĲο��źţ����ҵ�����֮��������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [slot0_ls,slot1_ls] = OFDM_lschannel(fredata)

%% ���ɷ��� ԭʼ��Ƶ�ź�
% rbnum = 100; % ��Դ�����
% cellid = 0;
% deltass =0;
% ndmrs1 = 0;
% cyc_shift = 0;
% symbol_index_slot0 = 3;  % ÿ��ʱ϶�ķ���3Ϊ��Ƶ,��0��ʼ
% symbol_index_slot1 = 3;
% subframeno =2 ;
% slotno = subframeno*2;
% [rs_slot1,rs_local_slot1] = OFDM_pusch_rs_gen(rbnum,0,0,slotno,cellid,deltass,ndmrs1,cyc_shift,symbol_index_slot0);
% [rs_slot2,rs_local_slot2] = OFDM_pusch_rs_gen(rbnum,0,0,slotno+1,cellid,deltass,ndmrs1,cyc_shift,symbol_index_slot1);
rs_slot = load('rs_slot.mat');
rs_slot1 = rs_slot.rs_slot1;
rs_slot2 = rs_slot.rs_slot2;
%% �ն˾����ŵ���Ƶ�ź�  
rs0fredata = fredata(4,:);   % ȡʱ϶1��Ƶ����
rs1fredata = fredata(11,:);  % ȡʱ϶2��Ƶ����
   
%% �ŵ�����
slot0_ls = rs0fredata./rs_slot1;    % ������������̵ķ��ǵ��ڱ������ķ��Ǽ�ȥ�����ķ���,�̵�ģ���ڱ������ͳ�����ģ����
slot1_ls = rs1fredata./rs_slot2;

end
   
   