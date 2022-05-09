%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfRxTrchDecoder.m
%  Description:         传输信道译码器
%  Reference:           3GPP TS 25.212, 4.2.3 Channel coding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	输出经过信道译码后的数据 
%       Input Parameter
%           input_data	输入待译码的数据

%           coder_type  编码器类型，0表示不编码，1表示1/2卷积码，2表示1/3卷积码             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-12
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out_data] = OFDM_RxTrchDecoder(input_data, coder_type)
input_num=length(input_data);
%% 功能实现
switch coder_type
	case 0
        out_data = zeros(1, input_num);	%#ok
        out_data = input_data;
    % 1/2卷积
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
        out_data = out_data(1, 1:len-6);      %去掉尾比特
    % 1/3卷积
    case 2
        len = input_num/3;
        out_data = zeros(1, len);       %#ok
        CodeGenerator = [557, 663, 711];
        K = 9;
        trellis = poly2trellis(K, CodeGenerator);
        out_data = vitdec(input_data, trellis, len,'trunc','hard'); 
        out_data = out_data(1, 1:len-8);      %去掉尾比特
    case 3
        fprintf('error:函数mfRxTrchDecoder的参数coder_type=3暂不支持\n');
    otherwise
        fprintf('error:函数mfRxTrchDecoder的参数coder_type输入错误\n');
end    

end