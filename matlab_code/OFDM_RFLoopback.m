function [rxdataIQ] = OFDM_RFLoopback(txdataIQ,pcip,xsrpip)

%%�����ݳ��Ƚ��в�������ɾ��
SAMPLE_LENGTH = 30720;                  % ������30.72Msps * 1ms
TxdataI=zeros(1,SAMPLE_LENGTH);
TxdataQ=zeros(1,SAMPLE_LENGTH);
if length(txdataIQ)>=SAMPLE_LENGTH
    TxdataI=real(txdataIQ(1,1:SAMPLE_LENGTH));
    TxdataQ=imag(txdataIQ(1,1:SAMPLE_LENGTH));
else 
    TxdataI(1,1:length(txdataIQ))=real(txdataIQ);
    TxdataQ(1,1:length(txdataIQ))=imag(txdataIQ);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�������ݴ���
%�Ŵ��ֵ������ȡ��
len = SAMPLE_LENGTH*2;
dataIQ = zeros(1,len);
dataIQ(1,1:2:len-1) = TxdataI(1,:);
dataIQ(1,2:2:len) = TxdataQ(1,:);
dataIQ = dataIQ.*(2047/max(dataIQ));    %�Ŵ��ֵ��2000,�ӽ����۷�ֵ2047
dataIQ = fix(dataIQ);                   %������ǿ��ȡ��

%��ֹ��������Ը������в������
for n = 1 : len
    if dataIQ(n) > 2047
      dataIQ(n) = 2047;
    elseif  dataIQ(n) < 0
      dataIQ(n) = 4096 + dataIQ(n);
    end
end

%���ӿڶ������б�����
dataIQ(1,1:2:len-1) = dataIQ(1,1:2:len).*16;    %I·��b11~b0 ��4bits
dataIQ(1,2:2:len) = fix(dataIQ(1,2:2:len)./256) + rem(dataIQ(1,2:2:len),256).*256;  %Q·��b7~b0 ��4bits b11~b8
dataIQ = uint16(dataIQ);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�������ò�������
test_set_sync_clock = uint8(hex2dec({'00','00','99','bb',  '69','00','00','00',  '00','00','00','00',  '00','00','00','00',  '00','00','00','00'}));%OK
test_Set_router = uint8(hex2dec({'00','00','99','bb', '68','00','00','00',  '00','06','00','00',  '00','00','00','00',  '00','00','00','00'}));%���ڻ���%OK
test_set_delay_system = uint8(hex2dec({'00','00','99','bb', '67','00','00','00',  '00','00','00','00',  '00','00','00','00',  '00','00','00','00'}));
test_tx_command = uint8(hex2dec({'00','00','99','bb', '65','02','00','03',  '00','01','78','00',  '00','00','00','00',  '00','00','00','00'}));%0A  10��ʱ϶��03FF ʱ϶����000001111111111��0000 ��Ƶ��7800 ���ݸ���/ʱ϶30720%OK
%test_tx_command = uint8(hex2dec({'00','00','99','bb', '65','0A','03','FF',  '00','03','78','00',  '00','00','00','00',  '00','00','00','00'}));%0A  10��ʱ϶��03FF ʱ϶����000001111111111��0000 ��Ƶ��7800 ���ݸ���/ʱ϶30720
test_Send_IQ = uint8(hex2dec({'00','00','99','bb', '64','00','00','00',  '00','00','00','00',  '00','00','00','00',  '00','00','00','00'}));
test_Get_IQ  = uint8(hex2dec({'00','00','99','bb', '66','01','00','01',  '00','80','00','F0',  '00','00','00','00',  '00','00','00','00'}));%01 �ɼ�ʱ϶�ţ�0000 ��Ƶ��0060 ��������96��00F0 ���Ĵ�С240��ʵ�ʽ����ֽ���Ϊ����ֵ����4��%OK
%test_Get_IQ  = uint8(hex2dec({'00','00','99','bb', '66','01','00','03',  '00','60','00','F0',  '00','00','00','00',  '00','00','00','00'}));%01 �ɼ�ʱ϶�ţ�0000 ��Ƶ��0060 ��������96��00F0 ���Ĵ�С240��ʵ�ʽ����ֽ���Ϊ����ֵ����4��
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%����UDP���󣬲���
udp_obj = udp(xsrpip,13345,'LocalHost',pcip,'LocalPort',12345,'TimeOut',5,'OutputBufferSize',61440,'InputBufferSize',61440*10);
udp_obj.Timeout=5;
fopen(udp_obj);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%������������
fwrite(udp_obj, test_set_sync_clock, 'uint8');
fwrite(udp_obj, test_Set_router,  'uint8');
fwrite(udp_obj, test_set_delay_system, 'uint8');
fwrite(udp_obj, test_tx_command, 'uint8');
fwrite(udp_obj, test_Send_IQ, 'uint8');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�����ѵ�����
SEND_PACKET_LENGTH = 512;   %����UDP�����ȣ�����ΪU16������ÿ��UDP�������ֽ�����Ϊ512*2��
for pn = 1:fix(SAMPLE_LENGTH*2/SEND_PACKET_LENGTH)
    fwrite(udp_obj, dataIQ(1,((pn-1)*SEND_PACKET_LENGTH+1) : (pn*SEND_PACKET_LENGTH)), 'uint16');
end      
%fwrite(udp_obj, dataIQ(1,(pn*SEND_PACKET_LENGTH+1 ): (SAMPLE_LENGTH*2)),'uint16');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%���Ͳɼ������գ�������������
fwrite(udp_obj, test_Get_IQ, 'uint8');

%% �ɼ�������ʼ��
RECV_PACKET_LENGTH = 240*4;                         %���հ��ֽ�������СΪ����ֵ����4��
data_byte_numb = SAMPLE_LENGTH*4;                   %���������ֽ�����0��Ƶ1��IQ�����Ӧ3���ֽ�
udp_data_ri = zeros(1, SAMPLE_LENGTH);        
udp_data_rq = zeros(1, SAMPLE_LENGTH);
udp_data_rr0 = zeros(1, SAMPLE_LENGTH*4);
rxdataI = zeros(1,SAMPLE_LENGTH);
rxdataQ = zeros(1,SAMPLE_LENGTH);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%��ʼ��������
recvInd = 1;
data_byte_c = 0;
while recvInd == 1    
    % �����ڶ�����
    [udp_data,count] = fread(udp_obj,RECV_PACKET_LENGTH);
    if count==0
        recvInd=0;
    end
    %��������ƴ��
    for (pj = 1 : count)
        udp_data_rr0(data_byte_c+pj) = udp_data(pj);
    end
    data_byte_c = data_byte_c + count;
    %�жϽ������ֽ���
    if ((data_byte_c>=data_byte_numb) || (data_byte_c==0))        %������ݽ�����ɻ�ʱû�н��յ��������˳�            
        recvInd = 0;    % ֹͣ����          
    end     
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�ر�UDP����
fclose(udp_obj);
delete(udp_obj);
clear udp_obj;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�������ݴ���
freqDiv=1;
 [rxdataI,rxdataQ]=OFDM_RxDataDeal(udp_data_rr0,freqDiv,data_byte_numb);

rxdataIQ=rxdataI+rxdataQ*i;
rxdataIQ=rxdataIQ;
%plot(rxdataI)
end