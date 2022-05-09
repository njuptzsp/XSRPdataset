%% ��Դ
function info_data = NR_SourceData(tbsize)
tb_width = 300;%����ԴͼƬ����ͬ���
tb_height = 0;%����ԴͼƬ����tbsize��С�ò�ͬ�ĸ߶�
switch tbsize
    case 8456 % 300*28 = 8400     
        tb_height = 28;
    case 16896 % 300*56 = 16800   
        tb_height = 56;
    case 10504 % 300*35 = 10500    
        tb_height = 35;
    case 21000 % 300*70 = 21000     
        tb_height = 70;
    case 19464 % 300*64 = 19200   
        tb_height = 64;
    case 38936 % 300*129 =38700   
        tb_height = 129;
    case 37896 % 300*126 =37800      
        tb_height = 126;
    case 75792 % 300*250 =75000
        tb_height = 250;
    case 28792 % 300*95 = 28500
        tb_height = 95;
    otherwise
        disp('error tbsize' );
end

%% ���ɱ�׼ͼƬ���ݣ�ͼƬ���300*250
% width = 300; %�̶�����
% hight = 250; %�̶�����
% 
% ini_r = 0;
% img_data = zeros(hight,width);
% for n=1:5
%     ini_c = ini_r;
%     for m=1:50
%         for i=1:300 
%             if mod(i-1,50)==0
%                 ini_c = abs(ini_c-1);
%             end
%             img_data((n-1)*50+m,i) = ini_c;
%         end
%     end
%     ini_r= abs(ini_r-1);
%     
% end                
% save img_data 

load img_data.mat  %��������Դ250*300����Ӧ��*�߾���300*250

img_data = img_data(1:tb_height,:); %��ȡ��Ҫ���ݴ�С
imwrite(img_data,'C:\vlab\http_labview\NG\pusch5Glink\tx_img.bmp','bmp'); %д�뷢��ͼƬ

padding_len = tbsize-tb_width * tb_height; %������ݳ���
padding_bits = zeros(1,padding_len); %��䲹��

img_data_s = reshape(img_data',1,tb_width*tb_height) ;%תΪ��������              

info_data = [img_data_s,padding_bits]; %��Դ��������

end



