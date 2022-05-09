%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   input
%       txdataIQ    ����IQ����
%       divFreq     ��Ƶ
%       recv_len    ����IQ���㳤��
%       pcip        PC IP��ַ
%       xsrpip      XSRP IP��ַ
%       type        ����Ӳ�����ܣ�0��ʾDA��1��ʾ��Ƶ���գ�2��ʾ��Ƶ������3��ʾ��Ƶ����
%   output
%       txdataIQ    ����IQ���ݣ�ʵ�ʣ�
%       rxdataIQ    ����IQ����
%       t1          ����IQ����ʱ����
%       t2          ����IQ����ʱ����
%       actual_fs   ������������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [txdataIQ,rxdataIQ,t1,t2,actual_fs,message] = XSRP_RFLoopback(txdataIQ,divFreq,recv_len,pcip,xsrpip,type)
function [rxdataIQ,message] = XSRP_RFLoopback(txdataIQ,divFreq,recv_len,pcip,xsrpip,type)
try
    %% ����UDP���󣬲���
    echoudp('off');
    echoudp('on',12345);
    udp_obj = udp(xsrpip,13345,'LocalHost',pcip,'LocalPort',12345,'TimeOut',2,'OutputBufferSize',61440,'InputBufferSize',61440*10);
    fopen(udp_obj);

    %% ���Ϳ�������
    % ��1��ʱ�Ӻ�����֡ͬ��ѡ��Ĭ�ϣ�
    test_set_sync_clock = uint8(hex2dec({'00','00','99','bb',   '69',   '00','00','00',  '00','00','00','00',  '00','00','00','00',  '00','00','00','00'}));
    % ��2��·��
    test_Set_router = uint8(hex2dec({'00','00','99','bb',       '68',   '00','00','06',  '00','06','00','00',  '00','00','00','00',  '00','00','00','00'}));%���ڻ���
    % ��3����������ʱ��ϵͳѡ��Ĭ�ϣ�
    test_set_delay_system = uint8(hex2dec({'00','00','99','bb', '67',   '00','00','09',  '00','00','00','00',  '00','00','00','00',  '00','00','00','00'}));

    fwrite(udp_obj, test_set_sync_clock, 'uint8');
    fwrite(udp_obj, test_Set_router,  'uint8');
    fwrite(udp_obj, test_set_delay_system, 'uint8');

    %% ����IQ����
    if type~=3 
        %% �����ݳ��Ƚ��в�������ɾ������С1000�����30720��
        MIN_LENGTH = 1000;
        MAX_LENGTH = 30720;
        % SAMPLE_LENGTH ���ͷ���������                 
        if length(txdataIQ)>MAX_LENGTH
            SAMPLE_LENGTH = MAX_LENGTH;
        elseif length(txdataIQ)<MIN_LENGTH
            SAMPLE_LENGTH = MIN_LENGTH;
        else
            SAMPLE_LENGTH = length(txdataIQ);
        end
        txdataIQ = [txdataIQ,zeros(1,MIN_LENGTH)];
        TxdataI=real(txdataIQ(1,1:SAMPLE_LENGTH));
        TxdataQ=imag(txdataIQ(1,1:SAMPLE_LENGTH));

        txdataIQ = TxdataI+i*TxdataQ;
        %% �������ݴ���
        % �Ŵ��ֵ������ȡ��
        len = SAMPLE_LENGTH*2;
        dataIQ = zeros(1,len);
        dataIQ(1,1:2:len-1) = TxdataI(1,:);
        dataIQ(1,2:2:len) = TxdataQ(1,:);
        dataIQ = dataIQ.*(2047/max(abs(dataIQ)));    %�Ŵ��ֵ��2000,�ӽ����۷�ֵ2047
        dataIQ = fix(dataIQ);                   %������ǿ��ȡ��

        % ��ֹ��������Ը������в������
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


        %% ����ʱ϶�ṹ��������
        test_tx_command = uint8(hex2dec({'00','00','99','bb',       '65',   '0A','03','FF',  '00','00','78','00',  '00','00','00','00',  '00','00','00','00'}));%0A  10��ʱ϶��03FF ʱ϶����000001111111111��0000 0��Ƶ��7800 ���ݸ���/ʱ϶30720
        % 0A һ֡��ʱ϶����10��Ĭ�Ϲ̶�
        % 03 FF 10��ʱ϶ȫ������Ĭ�Ϲ̶�
        % ��Ƶ
        div_freq_L8 = uint8(mod(divFreq,256));
        div_freq_H8 = uint8(floor(divFreq/256));
        test_tx_command(9) = div_freq_H8;
        test_tx_command(10) = div_freq_L8;
        % ʱ϶IQ�������
        data_Len_L8 = uint8(mod(SAMPLE_LENGTH,256));
        data_Len_H8 = uint8(floor(SAMPLE_LENGTH/256));
        test_tx_command(11) = data_Len_H8;
        test_tx_command(12) = data_Len_L8;
        %% �������ݿ�ʼ����
        test_Send_IQ = uint8(hex2dec({'00','00','99','bb',          '64',   '00','00','00',  '00','00','00','00',  '00','00','00','00',  '00','00','00','00'}));

        fwrite(udp_obj, test_tx_command, 'uint8');
        fwrite(udp_obj, test_Send_IQ, 'uint8');

        %% �����ѵ�����
        SEND_PACKET_LENGTH = 512;   %����UDP�����ȣ�����ΪU16������ÿ��UDP�������ֽ�����Ϊ512*2
        for pn = 1:fix(SAMPLE_LENGTH*2/SEND_PACKET_LENGTH)
            fwrite(udp_obj, dataIQ(1,((pn-1)*SEND_PACKET_LENGTH+1) : (pn*SEND_PACKET_LENGTH)), 'uint16');
        end      
        fwrite(udp_obj, dataIQ(1,(pn*SEND_PACKET_LENGTH+1 ): end),'uint16');
    else
        txdataIQ = 0;
    end

    %% ����
    if (type ==1)||(type==3) %% ��Ƶ�շ�  �� ��Ƶ����
        %% �ɼ�������ʼ��
        UDP_PACKET_BYTE_LEN = 960;%�̶�Ĭ�ϣ�����UDP���ֽڴ�С
        UDP_PACKET_BYTE_LEN = UDP_PACKET_BYTE_LEN/4;

        % recv_len ����IQ�������
        data_byte_numb = 0;               % ���������ֽ�����ʼ��
        if divFreq == 0
            data_byte_numb = recv_len*3;                % ���������ֽ�����0��Ƶ1��IQ�����Ӧ3���ֽ�
        else
            data_byte_numb = recv_len*4;                % ���������ֽ�������0��Ƶ1��IQ�����Ӧ4���ֽ�
        end

        UDP_PACKET_NUMS = ceil(data_byte_numb/UDP_PACKET_BYTE_LEN); % ����UDP�� ����

        udp_data_rr0 = zeros(1, data_byte_numb);        % UDP�����ֽ����ݳ�ʼ��
        udp_data_ri = zeros(1, recv_len);   % ����I·����    
        udp_data_rq = zeros(1, recv_len);   % ����Q·����

        %% �������ݿ�ʼ����
        test_Get_IQ  = uint8(hex2dec({'00','00','99','bb',          '66',   '01','00','00',  '00','60','00','F0',  '00','00','00','00',  '00','00','00','00'}));%01 �ɼ�ʱ϶�ţ�0000 ��Ƶ��0060 ��������96��00F0 ���Ĵ�С240��ʵ�ʽ����ֽ���Ϊ����ֵ����4��
        % �ɼ�ʱ϶�� 1��Ĭ�Ϲ̶�
        % ��Ƶ
        div_freq_L8 = uint8(mod(divFreq,256));
        div_freq_H8 = uint8(floor(divFreq/256));
        test_Get_IQ(7) = div_freq_H8;
        test_Get_IQ(8) = div_freq_L8;

        UDP_PACKET_NUMS_L8 = uint8(mod(UDP_PACKET_NUMS,256));
        UDP_PACKET_NUMS_H8 = uint8(floor(UDP_PACKET_NUMS/256));
        test_Get_IQ(9) = UDP_PACKET_NUMS_H8;
        test_Get_IQ(10) = UDP_PACKET_NUMS_L8;

        UDP_PACKET_BYTE_LEN_L8 = uint8(mod(UDP_PACKET_BYTE_LEN,256));
        UDP_PACKET_BYTE_LEN_H8 = uint8(floor(UDP_PACKET_BYTE_LEN/256));
        test_Get_IQ(11) = UDP_PACKET_BYTE_LEN_H8;
        test_Get_IQ(12) = UDP_PACKET_BYTE_LEN_L8;

        %% ���Ͳɼ������գ�������������
        fwrite(udp_obj, test_Get_IQ, 'uint8');

        %% ��ʼ��������
        UDP_PACKET_NUM = 0;
        recvInd = 1;
        data_byte_c = 0;
        while recvInd == 1    
            %�����ڶ�����
            [udp_data,count] = fread(udp_obj,UDP_PACKET_BYTE_LEN);
            %��������ƴ��
            udp_data_rr0(1,data_byte_c+1:data_byte_c+count) = udp_data;
            data_byte_c = data_byte_c + count;
            %�жϽ������ֽ���
            if(data_byte_c>=data_byte_numb)                 
                recvInd = 0;    % ֹͣ����          
            end
            % �˳�����
            UDP_PACKET_NUM=UDP_PACKET_NUM+1;
            if count == 0
                recvInd = 0;    % ֹͣ����
            end
            if UDP_PACKET_NUM == UDP_PACKET_NUMS
                recvInd = 0;    % ֹͣ����
            end
        end

        %% �������ݴ���
        %divFreq==0��6���ֽں�2��I��2��Q
        if divFreq==0
            for m=1:data_byte_numb/3 
                %�������н�������
                udp_data_ri(m) = udp_data_rr0(m*3-2)*16 + fix((udp_data_rr0(m*3-1))/16);
                temp=udp_data_rr0(m*3-1);
                udp_data_rq(m) = (mod(temp,16)) * 256 + udp_data_rr0(m*3);
                %�����Ĵ���
                if(udp_data_ri(m)>=2047)
                    udp_data_ri(m) = udp_data_ri(m)-4096;
                end
                if(udp_data_rq(m)>=2047)
                    udp_data_rq(m) = udp_data_rq(m)-4096;
                end
            end
        %divFreq��0��4���ֽں�1��I��1��Q
        else		
            for m=1:data_byte_numb/4
                %�������н�������
                udp_data_ri(m) = udp_data_rr0(m*4-3) * 256 + udp_data_rr0(m*4-2);
                udp_data_rq(m) = udp_data_rr0(m*4-1) * 256 + udp_data_rr0(m*4);
                %�����Ĵ���
                if(udp_data_ri(m)>=2047)
                    udp_data_ri(m) = udp_data_ri(m)-4096;
                end
                if(udp_data_rq(m)>=2047)
                    udp_data_rq(m) = udp_data_rq(m)-4096;
                end
            end
        end

        udp_data_ri = udp_data_ri/2047;
        udp_data_rq = udp_data_rq/2047;

        rxdataIQ = udp_data_ri+udp_data_rq*i;
    else
        rxdataIQ = 0; 
    end

    %% �ر�UDP����
    fclose(udp_obj);
    delete(udp_obj);
    clear udp_obj;
    echoudp('off');

%     base_fs = 30.72*10^6;           % ��׼������
%     actual_fs = base_fs/(divFreq+1) % ʵ�����ò����ʣ�������źŷ������ʣ�
%     dt = 1/actual_fs;
%     t1 = 0:dt:(length(txdataIQ)-1)*dt;
%     t2 = 0:dt:(recv_len-1)*dt;
    
    message = 'success';
catch ErrorInfo
    message = ErrorInfo.message;
%     txdataIQ = 0;
    rxdataIQ = 0;
%     t1 = 0;
%     t2 = 0;
%     actual_fs = 0;
end

end