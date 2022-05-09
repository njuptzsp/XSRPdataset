%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   input
%       txdataIQ    发送IQ数据
%       divFreq     分频
%       recv_len    接收IQ样点长度
%       pcip        PC IP地址
%       xsrpip      XSRP IP地址
%       type        调用硬件功能，0表示DA，1表示射频发收，2表示射频单发，3表示射频单收
%   output
%       txdataIQ    发送IQ数据（实际）
%       rxdataIQ    接收IQ数据
%       t1          发送IQ数据时间轴
%       t2          接收IQ数据时间轴
%       actual_fs   基带符号速率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [txdataIQ,rxdataIQ,t1,t2,actual_fs,message] = XSRP_RFLoopback(txdataIQ,divFreq,recv_len,pcip,xsrpip,type)
function [rxdataIQ,message] = XSRP_RFLoopback(txdataIQ,divFreq,recv_len,pcip,xsrpip,type)
try
    %% 创建UDP对象，并打开
    echoudp('off');
    echoudp('on',12345);
    udp_obj = udp(xsrpip,13345,'LocalHost',pcip,'LocalPort',12345,'TimeOut',2,'OutputBufferSize',61440,'InputBufferSize',61440*10);
    fopen(udp_obj);

    %% 发送控制命令
    % （1）时钟和上行帧同步选择（默认）
    test_set_sync_clock = uint8(hex2dec({'00','00','99','bb',   '69',   '00','00','00',  '00','00','00','00',  '00','00','00','00',  '00','00','00','00'}));
    % （2）路由
    test_Set_router = uint8(hex2dec({'00','00','99','bb',       '68',   '00','00','06',  '00','06','00','00',  '00','00','00','00',  '00','00','00','00'}));%网口环回
    % （3）上下行延时和系统选择（默认）
    test_set_delay_system = uint8(hex2dec({'00','00','99','bb', '67',   '00','00','09',  '00','00','00','00',  '00','00','00','00',  '00','00','00','00'}));

    fwrite(udp_obj, test_set_sync_clock, 'uint8');
    fwrite(udp_obj, test_Set_router,  'uint8');
    fwrite(udp_obj, test_set_delay_system, 'uint8');

    %% 发送IQ数据
    if type~=3 
        %% 对数据长度进行补零或溢出删除（最小1000，最大30720）
        MIN_LENGTH = 1000;
        MAX_LENGTH = 30720;
        % SAMPLE_LENGTH 发送符号样点数                 
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
        %% 发送数据处理
        % 放大峰值，浮点取整
        len = SAMPLE_LENGTH*2;
        dataIQ = zeros(1,len);
        dataIQ(1,1:2:len-1) = TxdataI(1,:);
        dataIQ(1,2:2:len) = TxdataQ(1,:);
        dataIQ = dataIQ.*(2047/max(abs(dataIQ)));    %放大峰值至2000,接近理论峰值2047
        dataIQ = fix(dataIQ);                   %浮点数强制取整

        % 防止溢出，并对负数进行补码操作
        for n = 1 : len
            if dataIQ(n) > 2047
                dataIQ(n) = 2047;
            elseif  dataIQ(n) < 0
                dataIQ(n) = 4096 + dataIQ(n);
            end
        end

        %按接口定义排列比特序
        dataIQ(1,1:2:len-1) = dataIQ(1,1:2:len).*16;    %I路：b11~b0 空4bits
        dataIQ(1,2:2:len) = fix(dataIQ(1,2:2:len)./256) + rem(dataIQ(1,2:2:len),256).*256;  %Q路：b7~b0 空4bits b11~b8
        dataIQ = uint16(dataIQ);


        %% 发送时隙结构控制命令
        test_tx_command = uint8(hex2dec({'00','00','99','bb',       '65',   '0A','03','FF',  '00','00','78','00',  '00','00','00','00',  '00','00','00','00'}));%0A  10个时隙，03FF 时隙开关000001111111111，0000 0分频，7800 数据个数/时隙30720
        % 0A 一帧中时隙个数10，默认固定
        % 03 FF 10个时隙全部开，默认固定
        % 分频
        div_freq_L8 = uint8(mod(divFreq,256));
        div_freq_H8 = uint8(floor(divFreq/256));
        test_tx_command(9) = div_freq_H8;
        test_tx_command(10) = div_freq_L8;
        % 时隙IQ样点个数
        data_Len_L8 = uint8(mod(SAMPLE_LENGTH,256));
        data_Len_H8 = uint8(floor(SAMPLE_LENGTH/256));
        test_tx_command(11) = data_Len_H8;
        test_tx_command(12) = data_Len_L8;
        %% 发射数据开始命令
        test_Send_IQ = uint8(hex2dec({'00','00','99','bb',          '64',   '00','00','00',  '00','00','00','00',  '00','00','00','00',  '00','00','00','00'}));

        fwrite(udp_obj, test_tx_command, 'uint8');
        fwrite(udp_obj, test_Send_IQ, 'uint8');

        %% 发送已调数据
        SEND_PACKET_LENGTH = 512;   %发送UDP包长度，数据为U16，所以每个UDP包发送字节数数为512*2
        for pn = 1:fix(SAMPLE_LENGTH*2/SEND_PACKET_LENGTH)
            fwrite(udp_obj, dataIQ(1,((pn-1)*SEND_PACKET_LENGTH+1) : (pn*SEND_PACKET_LENGTH)), 'uint16');
        end      
        fwrite(udp_obj, dataIQ(1,(pn*SEND_PACKET_LENGTH+1 ): end),'uint16');
    else
        txdataIQ = 0;
    end

    %% 接收
    if (type ==1)||(type==3) %% 射频收发  或 射频单收
        %% 采集变量初始化
        UDP_PACKET_BYTE_LEN = 960;%固定默认，接收UDP包字节大小
        UDP_PACKET_BYTE_LEN = UDP_PACKET_BYTE_LEN/4;

        % recv_len 接收IQ样点个数
        data_byte_numb = 0;               % 接收数据字节数初始化
        if divFreq == 0
            data_byte_numb = recv_len*3;                % 接收数据字节数，0分频1个IQ样点对应3个字节
        else
            data_byte_numb = recv_len*4;                % 接收数据字节数，非0分频1个IQ样点对应4个字节
        end

        UDP_PACKET_NUMS = ceil(data_byte_numb/UDP_PACKET_BYTE_LEN); % 接收UDP包 个数

        udp_data_rr0 = zeros(1, data_byte_numb);        % UDP接收字节数据初始化
        udp_data_ri = zeros(1, recv_len);   % 接收I路数据    
        udp_data_rq = zeros(1, recv_len);   % 接收Q路数据

        %% 接收数据开始命令
        test_Get_IQ  = uint8(hex2dec({'00','00','99','bb',          '66',   '01','00','00',  '00','60','00','F0',  '00','00','00','00',  '00','00','00','00'}));%01 采集时隙号，0000 分频，0060 包的数量96，00F0 包的大小240（实际接收字节数为配置值乘以4）
        % 采集时隙号 1，默认固定
        % 分频
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

        %% 发送采集（接收）数据启动命令
        fwrite(udp_obj, test_Get_IQ, 'uint8');

        %% 开始接收数据
        UDP_PACKET_NUM = 0;
        recvInd = 1;
        data_byte_c = 0;
        while recvInd == 1    
            %从网口读数据
            [udp_data,count] = fread(udp_obj,UDP_PACKET_BYTE_LEN);
            %接收数据拼接
            udp_data_rr0(1,data_byte_c+1:data_byte_c+count) = udp_data;
            data_byte_c = data_byte_c + count;
            %判断接收总字节数
            if(data_byte_c>=data_byte_numb)                 
                recvInd = 0;    % 停止运行          
            end
            % 退出机制
            UDP_PACKET_NUM=UDP_PACKET_NUM+1;
            if count == 0
                recvInd = 0;    % 停止运行
            end
            if UDP_PACKET_NUM == UDP_PACKET_NUMS
                recvInd = 0;    % 停止运行
            end
        end

        %% 接收数据处理
        %divFreq==0，6个字节含2个I和2个Q
        if divFreq==0
            for m=1:data_byte_numb/3 
                %重新排列接收数据
                udp_data_ri(m) = udp_data_rr0(m*3-2)*16 + fix((udp_data_rr0(m*3-1))/16);
                temp=udp_data_rr0(m*3-1);
                udp_data_rq(m) = (mod(temp,16)) * 256 + udp_data_rr0(m*3);
                %负数的处理
                if(udp_data_ri(m)>=2047)
                    udp_data_ri(m) = udp_data_ri(m)-4096;
                end
                if(udp_data_rq(m)>=2047)
                    udp_data_rq(m) = udp_data_rq(m)-4096;
                end
            end
        %divFreq非0，4个字节含1个I和1个Q
        else		
            for m=1:data_byte_numb/4
                %重新排列接收数据
                udp_data_ri(m) = udp_data_rr0(m*4-3) * 256 + udp_data_rr0(m*4-2);
                udp_data_rq(m) = udp_data_rr0(m*4-1) * 256 + udp_data_rr0(m*4);
                %负数的处理
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

    %% 关闭UDP对象
    fclose(udp_obj);
    delete(udp_obj);
    clear udp_obj;
    echoudp('off');

%     base_fs = 30.72*10^6;           % 基准采样率
%     actual_fs = base_fs/(divFreq+1) % 实际配置采样率（或基带信号符号速率）
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