%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_remap.m
%  Description:         物理资源映射
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	输出经过信道编码后的数据 
%       Input Parameter
%           moddata     传输业务数据
%           rs_slot1    信道1 导频数据
%           rs_slot2    信道2 导频数据
%           rbnum       资源快个数              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2021-01-06
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   初稿
% Remarks
%   两个时隙，14个OFDM符号，1~7，8~14，位置4、11分别放置时隙1和时隙2的导频信号
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = OFDM_remap(moddata,rs_slot1,rs_slot2,rbnum)

temp = reshape(moddata,rbnum*12,12)'; %rbnum*12 一个资源块12个子载波
temp = conj(temp);  % 共轭，因为上一步reshape后复数共轭转置
out = [temp(1:3,:);rs_slot1;temp(4:9,:);rs_slot2;temp(10:12,:)];

end


