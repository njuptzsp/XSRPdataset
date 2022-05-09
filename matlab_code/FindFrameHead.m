function [ searchflag,timestart,corrdata,output ] = FindFrameHead( input_data,syn_data )
len = 28672;
cross_data = zeros(1,len);
for i=1:len
    cross_data(i)  = input_data(1,i:i+2048-1)*syn_data';
end

corrdata=abs(cross_data);

%�ж���ط��Ƿ�����
timestart=find(max(corrdata)==corrdata);
if max(corrdata) > 2*(sum(corrdata)-max(corrdata))/(len-1)
    searchflag = 1;
else
    searchflag = 0;
end

if searchflag
    
    %% ��ȡ��Ч����
    pos = 6737;  %��һ����Ƶ���ŵ�λ�ã�160+2048*3+144*3+1=6737��
    if (timestart <=pos)  % ˵���������ӳ��ˣ���Ҫ���ƶ�
        leftpos = pos - timestart;
        output = [input_data(1,(30720-leftpos+1):30720),input_data(1,1:(30720-leftpos))];   
    else  %˵����������ǰ�ˣ���Ҫ���ƶ�
        rightpos = timestart - pos;
        output = [input_data(1,rightpos+1:30720),input_data(1,1:rightpos)];
    end
else
    output = zeros(1,30720);
end