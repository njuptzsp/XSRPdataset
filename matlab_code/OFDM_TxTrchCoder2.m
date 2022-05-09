function [ out_data ] = OFDM_TxTrchCoder2( input_data, coder_type )
input_num=length(input_data);
%% ����ʵ��
switch coder_type
	case 0
        out_data = zeros(1, input_num);     %#ok
        out_data = input_data;
    % 1/2���
    case 1
%         CodeGenerator = [171,133];
% K = 7;
        %���β���أ����������ݺ����8��0��
        temp_data = zeros(1, input_num+8);
        temp_data(1,1:input_num) = input_data;
        input_num = input_num+8;
        %�������
        out_data = zeros(1, input_num*2);     %#ok
        reg = zeros(1,6);
        for n=1:input_num
            first_temp = xor(xor(xor(xor(temp_data(n),reg(1)),reg(2)),reg(3)),reg(6));
            second_temp = xor(xor(xor(xor(temp_data(n),reg(2)),reg(3)),reg(5)),reg(6));
            reg(6)=reg(5);
            reg(5)=reg(4);
            reg(4)=reg(3);
            reg(3)=reg(2);
            reg(2)=reg(1);
            reg(1)=temp_data(n);
            out_data(1,(n-1)*2+1:2*n)=[first_temp,second_temp];
        end
    % 1/3���
    case 2
        %���β���أ����������ݺ����8��0��
        temp_data = zeros(1, input_num+8);
        temp_data(1,1:input_num) = input_data;
        input_num = input_num+8;
        %�������
        out_data = zeros(1, input_num*3);     %#ok
        CodeGenerator = [557, 663, 711];  %���ɶ���ʽ
        K = 9;                           %Լ����
        trellis = poly2trellis(K, CodeGenerator);
        out_data = convenc(temp_data, trellis);  
    case 3
        fprintf('error:����mfTxTrchCoder�Ĳ���coder_type=3�ݲ�֧��\n');
    otherwise
        fprintf('error:����mfTxTrchCoder�Ĳ���coder_type�������\n');
end    


end

