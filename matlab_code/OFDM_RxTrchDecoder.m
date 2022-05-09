%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfRxTrchDecoder.m
%  Description:         �����ŵ�������
%  Reference:           3GPP TS 25.212, 4.2.3 Channel coding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	��������ŵ����������� 
%       Input Parameter
%           input_data	��������������

%           coder_type  ���������ͣ�0��ʾ�����룬1��ʾ1/2����룬2��ʾ1/3�����             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-12
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out_data] = OFDM_RxTrchDecoder(input_data, coder_type)
input_num=length(input_data);
%% ����ʵ��
switch coder_type
	case 0
        out_data = zeros(1, input_num);	%#ok
        out_data = input_data;
    % 1/2���
    case 1
        len = input_num/2;
        out_data = zeros(1, len);       %#ok
%         CodeGenerator = [561, 753];
%         K = 9;
        CodeGenerator = [171,133];
        K = 7;
        trellis = poly2trellis(K, CodeGenerator);
%         save('trellis.mat','trellis');
%         trellis_temp = load('trellis.mat');
%         trellis = trellis_temp.trellis;
        out_data = vitdec(input_data, trellis, len,'trunc','hard'); 
        out_data = out_data(1, 1:len-6);      %ȥ��β����
    % 1/3���
    case 2
        len = input_num/3;
        out_data = zeros(1, len);       %#ok
        CodeGenerator = [557, 663, 711];
        K = 9;
        trellis = poly2trellis(K, CodeGenerator);
        out_data = vitdec(input_data, trellis, len,'trunc','hard'); 
        out_data = out_data(1, 1:len-8);      %ȥ��β����
    case 3
        fprintf('error:����mfRxTrchDecoder�Ĳ���coder_type=3�ݲ�֧��\n');
    otherwise
        fprintf('error:����mfRxTrchDecoder�Ĳ���coder_type�������\n');
end    

end