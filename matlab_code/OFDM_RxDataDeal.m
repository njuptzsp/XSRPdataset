%20171218�������޸Ŀ���

function [rxdataI,rxdataQ]=OFDM_RxDataDeal(udp_data_rr0,freqDiv,dataByteNumb)

%freqDiv==0��6���ֽں�2��I��2��Q
if(freqDiv==0)
	for m=1:dataByteNumb/3 
        %�������н�������
        udp_data_ri(m) = udp_data_rr0(m*3-2)*16 + fix((udp_data_rr0(m*3-1))/16);
        temp=udp_data_rr0(m*3-1);
        udp_data_rq(m) = (mod(temp,16)) * 256 + udp_data_rr0(m*3);
        %�����Ĵ���
        if(udp_data_ri(m)>=2049)
            udp_data_ri(m) = udp_data_ri(m)-4096;
        end
        if(udp_data_rq(m)>=2049)
            udp_data_rq(m) = udp_data_rq(m)-4096;
        end
%         udp_data_ri(m)= udp_data_ri(m)/52144;       %��
%         udp_data_rq(m)= udp_data_rq(m)/52144;       %��
    end
%freqDiv==0��4���ֽں�1��I��1��Q
else		
	for m=1:dataByteNumb/4
        %�������н�������
		udp_data_ri(m) = udp_data_rr0(m*4-3) * 256 + udp_data_rr0(m*4-2);
        udp_data_rq(m) = udp_data_rr0(m*4-1) * 256 + udp_data_rr0(m*4);
        %�����Ĵ���
        if(udp_data_ri(m)>=2049)
            udp_data_ri(m) = udp_data_ri(m)-4096;
        end
        if(udp_data_rq(m)>=2049)
            udp_data_rq(m) = udp_data_rq(m)-4096;
        end
%         udp_data_ri(m)= udp_data_ri(m)/52144;       %��
%         udp_data_rq(m)= udp_data_rq(m)/52144;       %��
	end
end

if(udp_data_ri(m)>2047)
 	udp_data_ri(m) = udp_data_ri(m)-4096;
end

if(udp_data_rq(m)>2047)
      	udp_data_rq(m) = udp_data_rq(m)-4096;
end

udp_data_ri(m)= udp_data_ri(m)/2047;
udp_data_rq(m)= udp_data_rq(m)/2047;

rxdataI = udp_data_ri;               %������I·����
rxdataQ = udp_data_rq;		%������Q·����
end


