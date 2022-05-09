%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_equal.m
%  Description:         信道均衡
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	输出估计后数据，数据维度14*1200
%       Input Parameter
%           freadata     输入待均衡数据,数据维度14*1200    
%           slot0lschannel	时隙1估计后数据，数据维度1*1200
%           slot1lschannel	时隙2估计后数据，数据维度1*1200
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outequfredata = OFDM_equal(freqdata,slot0lschannel,slot1lschannel,rbnum)
numsym =14; % 总OFDM符号数
scnum = 12*rbnum ; % 子载波
outequfredata = zeros(12,scnum); % 12 是有效数据占用OFDM符号数
start = 1;
for n=1:numsym
    if n==4|n==11 %4、11为导频占用符号，不做处理
    else
        if n<=7 %时隙1
            outequfredata(start,:) = freqdata(n,:)./slot0lschannel; % 两复数相除，商的辐角等于被除数的辐角减去除数的辐角
        else
            outequfredata(start,:) = freqdata(n,:)./slot1lschannel; % 两复数相除，商的辐角等于被除数的辐角减去除数的辐角
        end
        start = start+1;
    end
end

end