%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_RxDemod.m
%  Description:         解调制映射
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	输出解调比特数据
%       Input Parameter
%           input_data  待解调制映射数据,数据维度12*1200    
%           mod_type	调制类型，1表示PQSK，2表示16QAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output_data] = OFDM_RxDemod(input_data,mod_type)
%% 把input_data并行数据转为串行数据数据,12*1200转为14400
ofdm_num = 12;
carr_num = 1200;
input_data_s = (reshape(input_data',ofdm_num*carr_num,1))';

%% 解调制映射
len=length(input_data_s);
demod_bit=zeros(1,mod_type*len*2);

if mod_type==1 %QPSK
        angleData=angle(input_data_s(1,:));        %求符号的相位值
        for n=1:len
            if (0<angleData(n)&&angleData(n)<pi/2)                 %第1象限
                demod_bit(1,(n-1)*2+1:n*2)=[0,0];
            elseif (pi/2<angleData(n)&&angleData(n)<pi)            %第2象限
                demod_bit(1,(n-1)*2+1:n*2)=[1,0];
            elseif (-pi<angleData(n)&&angleData(n)<-pi/2)          %第3象限
                demod_bit(1,(n-1)*2+1:n*2)=[1,1];
            elseif (-pi/2<angleData(n)&&angleData(n)<0)        %第4象限
                demod_bit(1,(n-1)*2+1:n*2)=[0,1];
            else
                demod_bit(1,(n-1)*2+1:n*2)=[0,0];
            end
        end
elseif mod_type==2 % 16QAM
    temp = 1/(10^0.5);%功率归一化因子
    d = 2*temp; % 水平或竖直两个IQ星座点距离
    for(iii=1:len)
         tmpdata1 =abs(real(input_data_s(1,iii))); 
         tmpdata2 =abs(imag(input_data_s(1,iii)));
        if(real(input_data_s(1,iii))>0)   %判断符号位于14象限还是23象限
            demod_bit(1,4*(iii-1)+1) = 0;%14象限
        else
            demod_bit(1,4*(iii-1)+1) = 1;%23象限
        end
        if(imag(input_data_s(1,iii))>0)%判断符号位于12象限，还是34象限
            demod_bit(1,4*(iii-1)+2) = 0;%12象限
        else
            demod_bit(1,4*(iii-1)+2) = 1;%34象限
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
    disp('不支持调制模式');
end
output_data=demod_bit;     
end
  