%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_RxDemod.m
%  Description:         �����ӳ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	��������������
%       Input Parameter
%           input_data  �������ӳ������,����ά��12*1200    
%           mod_type	�������ͣ�1��ʾPQSK��2��ʾ16QAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output_data] = OFDM_RxDemod(input_data,mod_type)
%% ��input_data��������תΪ������������,12*1200תΪ14400
ofdm_num = 12;
carr_num = 1200;
input_data_s = (reshape(input_data',ofdm_num*carr_num,1))';

%% �����ӳ��
len=length(input_data_s);
demod_bit=zeros(1,mod_type*len*2);

if mod_type==1 %QPSK
        angleData=angle(input_data_s(1,:));        %����ŵ���λֵ
        for n=1:len
            if (0<angleData(n)&&angleData(n)<pi/2)                 %��1����
                demod_bit(1,(n-1)*2+1:n*2)=[0,0];
            elseif (pi/2<angleData(n)&&angleData(n)<pi)            %��2����
                demod_bit(1,(n-1)*2+1:n*2)=[1,0];
            elseif (-pi<angleData(n)&&angleData(n)<-pi/2)          %��3����
                demod_bit(1,(n-1)*2+1:n*2)=[1,1];
            elseif (-pi/2<angleData(n)&&angleData(n)<0)        %��4����
                demod_bit(1,(n-1)*2+1:n*2)=[0,1];
            else
                demod_bit(1,(n-1)*2+1:n*2)=[0,0];
            end
        end
elseif mod_type==2 % 16QAM
    temp = 1/(10^0.5);%���ʹ�һ������
    d = 2*temp; % ˮƽ����ֱ����IQ���������
    for(iii=1:len)
         tmpdata1 =abs(real(input_data_s(1,iii))); 
         tmpdata2 =abs(imag(input_data_s(1,iii)));
        if(real(input_data_s(1,iii))>0)   %�жϷ���λ��14���޻���23����
            demod_bit(1,4*(iii-1)+1) = 0;%14����
        else
            demod_bit(1,4*(iii-1)+1) = 1;%23����
        end
        if(imag(input_data_s(1,iii))>0)%�жϷ���λ��12���ޣ�����34����
            demod_bit(1,4*(iii-1)+2) = 0;%12����
        else
            demod_bit(1,4*(iii-1)+2) = 1;%34����
        end
        if(tmpdata1>d)
            demod_bit(1,4*(iii-1)+3) = 1;
        else
            demod_bit(1,4*(iii-1)+3) = 0;
        end
        if(tmpdata2>d)
            demod_bit(1,4*(iii-1)+4) = 1;
        else
            demod_bit(1,4*(iii-1)+4) = 0;
        end
    end
else
    disp('��֧�ֵ���ģʽ');
end
output_data=demod_bit;     
end
  