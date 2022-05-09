%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_lschannel.m
%  Description:         信道估计
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           slot0_ls	时隙1估计后数据，数据维度1*1200
%           slot1_ls	时隙2估计后数据，数据维度1*1200
%       Input Parameter
%           fredata     输入待信道估计数据,数据维度14*1200             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   初稿
% Remarks
%       发端嵌入了一组预定义信号（这称为参考信号或导频信号）
%       当这些参考信号通过信道时，它会与其他信号一起失真（衰减，相移，噪声）
%       我们在接收方检测/解码接收到的参考信号
%       比较发送的参考信号和接收的参考信号，并找到它们之间的相关性
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [slot0_ls,slot1_ls] = OFDM_lschannel(fredata)

%% 生成发端 原始导频信号
% rbnum = 100; % 资源块个数
% cellid = 0;
% deltass =0;
% ndmrs1 = 0;
% cyc_shift = 0;
% symbol_index_slot0 = 3;  % 每个时隙的符号3为导频,从0开始
% symbol_index_slot1 = 3;
% subframeno =2 ;
% slotno = subframeno*2;
% [rs_slot1,rs_local_slot1] = OFDM_pusch_rs_gen(rbnum,0,0,slotno,cellid,deltass,ndmrs1,cyc_shift,symbol_index_slot0);
% [rs_slot2,rs_local_slot2] = OFDM_pusch_rs_gen(rbnum,0,0,slotno+1,cellid,deltass,ndmrs1,cyc_shift,symbol_index_slot1);
rs_slot = load('rs_slot.mat');
rs_slot1 = rs_slot.rs_slot1;
rs_slot2 = rs_slot.rs_slot2;
%% 收端经过信道后导频信号  
rs0fredata = fredata(4,:);   % 取时隙1导频数据
rs1fredata = fredata(11,:);  % 取时隙2导频数据
   
%% 信道估计
slot0_ls = rs0fredata./rs_slot1;    % 两复数相除，商的辐角等于被除数的辐角减去除数的辐角,商的模等于被除数和除数的模的商
slot1_ls = rs1fredata./rs_slot2;

end
   
   