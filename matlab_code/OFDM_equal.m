%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_equal.m
%  Description:         �ŵ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	������ƺ����ݣ�����ά��14*1200
%       Input Parameter
%           freadata     �������������,����ά��14*1200    
%           slot0lschannel	ʱ϶1���ƺ����ݣ�����ά��1*1200
%           slot1lschannel	ʱ϶2���ƺ����ݣ�����ά��1*1200
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outequfredata = OFDM_equal(freqdata,slot0lschannel,slot1lschannel,rbnum)
numsym =14; % ��OFDM������
scnum = 12*rbnum ; % ���ز�
outequfredata = zeros(12,scnum); % 12 ����Ч����ռ��OFDM������
start = 1;
for n=1:numsym
    if n==4|n==11 %4��11Ϊ��Ƶռ�÷��ţ���������
    else
        if n<=7 %ʱ϶1
            outequfredata(start,:) = freqdata(n,:)./slot0lschannel; % ������������̵ķ��ǵ��ڱ������ķ��Ǽ�ȥ�����ķ���
        else
            outequfredata(start,:) = freqdata(n,:)./slot1lschannel; % ������������̵ķ��ǵ��ڱ������ķ��Ǽ�ȥ�����ķ���
        end
        start = start+1;
    end
end

end