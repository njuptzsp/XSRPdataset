%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            OFDM_TxMod.m
%  Description:         ����ӳ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           output_data     ����ӳ�������
%       Input Parameter
%           input_data      �����Ʊ�������
%           mod_type        ���Ʒ�ʽ��1��QPSK��2��16QAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2020-10-09
%       Author:         LiuDong
%       Version:        1.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output_data] = OFDM_TxMod(input_data,mod_type)
bit_symbol=mod_type*2;  %һ�����Ʒ��Ŷ�Ӧ������
[num,bit_len]=size(input_data);
output_data=zeros(1,floor(bit_len/bit_symbol));%��ʼ������ӳ������

if mod_type==1  %QPSK���ƣ���1��0������ӳ��Ϊ��-1��1��
    temp = 1/(2^0.5); %���ʹ�һ������
    data_real=1-2*input_data(1,1:2:end);
    data_imag=1-2*input_data(1,2:2:end);
    output_data(1,:)=(data_real+data_imag*i)/temp;%
elseif mod_type==2; %16QAM���ƣ�
    temp = 1/(10^0.5);%���ʹ�һ������
    QAM16_table = temp*[(1+1i), (1+3j), (3+1i), (3+3j), (1-1i), (1-3j), (3-1i), (3-3j), ...
                    (-1+1i),(-1+3j),(-3+1i),(-3+3j),(-1-1i),(-1-3j),(-3-1i),(-3-3j)]; %16QAM����ӳ���
    for n=1:floor(bit_len/bit_symbol)
        output_data(1,n)=QAM16_table( input_data(1,(n-1)*4+1)*8+input_data(1,(n-1)*4+2)*4+input_data(1,(n-1)*4+3)*2+input_data(1,(n-1)*4+4)*1+1 );%����ӳ����������ж�Ӧ
    end
else
    disp('��֧�ֵ���ģʽ');
end

end
  