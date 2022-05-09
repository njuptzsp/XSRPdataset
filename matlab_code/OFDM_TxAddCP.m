function [output_data] = OFDM_TxAddCP (input_data)

%% ��1��ʱ϶
slot1=input_data(1:7,:);
cp=zeros(7,144);
for n=2:7  
    cp(n,:)=slot1(n,end-144+1:end); %��144��������Ϊѭ��ǰ׺
end
output_data1=[slot1(1,end-160+1:end),slot1(1,:),cp(2,:),slot1(2,:),cp(3,:),slot1(3,:),cp(4,:),slot1(4,:),cp(5,:),slot1(5,:),cp(6,:),slot1(6,:),cp(7,:),slot1(7,:)];%һ��ʱ϶����

%% ��2��ʱ϶
slot2=input_data(8:end,:);
cp=zeros(7,144);
for n=2:7   
    cp(n,:)=slot2(n,end-144+1:end); %��144��������Ϊѭ��ǰ׺
end
output_data2=[slot2(1,end-160+1:end),slot2(1,:),cp(2,:),slot2(2,:),cp(3,:),slot2(3,:),cp(4,:),slot2(4,:),cp(5,:),slot2(5,:),cp(6,:),slot2(6,:),cp(7,:),slot2(7,:)];%һ��ʱ϶����

output_data = [output_data1,output_data2];
end