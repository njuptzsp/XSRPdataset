%pusch channel reference signal generator
function [out,basic_out] = pusch_rs_gen(rbnum,group_hop_flag,seq_hop_flag,slotno,cellid,deltass,...
                          ndmrs1,cyc_shift,symbol_index)
   %rbnum： 占用的rb个数  
   %group_hop_flag  组跳频使能标志
   %seq_hop_flag  序列跳频标志
   %deltass  高层配置的组跳频参数
   %ndmrs1   广播中配置的参数，   
   %cyc_shift  DCI调度信息中给出
prime_table = [11,  23,  31,  47,  59,  71,  83,  89, 107, 113, 131, 139, 151, 167, 179, 191, 199, 211, 227, 239, ...
 251, 263, 271, 283, 293, 311, 317, 331, 347, 359, 367, 383, 389, 401, 419, 431, 443, 449, 467, 479, ...
 491, 503, 509, 523, 523, 547, 563, 571, 587, 599, 607, 619, 631, 647, 659, 661, 683, 691, 701, 719, ...
 727, 743, 751, 761, 773, 787, 797, 811, 827, 839, 839, 863, 863, 887, 887, 911, 919, 929, 947, 953, ...
 971, 983, 991, 997,1019,1031,1039,1051,1063,1069,1091,1103,1109,1123,1129,1151,1163,1171,1187,1193,2003]; %
ndmrs2_table=[0,2,3,4,6,8,9,10];
fai_12sc = [-1 , 1 , 3  , -3 , 3  ,3   , 1    ,1     ,3      ,1      ,-3     ,3        ;
1  ,1  ,3   ,  3 , 3  ,-1  ,  1   , -3   ,  -3   ,   1   ,   -3  ,   3     ;
1  ,1  ,-3  , -3 , -3 , -1 ,   -3 ,   -3 ,    1  ,    -3 ,     1 ,    -1   ;
-1 , 1 , 1  ,  1 , 1  ,-1  ,  -3  ,  -3  ,   1   ,   -3  ,    3  ,   -1    ;
-1 , 3 , 1  , -1 , 1  ,-1  ,  -3  ,  -1  ,   1   ,   -1  ,    1  ,   3     ;
1  ,-3 , 3  , -1 , -1 , 1  ,  1   , -1   ,  -1   ,   3   ,   -3  ,   1     ;
-1 , 3 , -3 , -3 , -3 , 3  ,  1   , -1   ,  3    ,  3    ,  -3   ,  1      ;
-3 , -1, -1 , -1 , 1  ,-3  ,  3   , -1   ,  1    ,  -3   ,   3   ,  1      ;
1  ,-3 , 3  ,  1 , -1 , -1 ,   -1 ,   1  ,   1   ,   3   ,   -1  ,   1     ;
1  ,-3 , -1 ,  3 , 3  ,-1  ,  -3  ,  1   ,  1    ,  1    ,  1    , 1       ;
-1 , 3 , -1 ,  1 , 1  ,-3  ,  -3  ,  -1  ,   -3  ,    -3 ,     3 ,    -1   ;
3  ,1  ,-1  , -1 , 3  ,3   , -3   , 1    , 3     , 1     , 3     ,3        ;
1  ,-3 , 1  ,  1 , -3 , 1  ,  1   , 1    , -3    ,  -3   ,   -3  ,   1     ;
3  ,3  ,-3  ,  3 , -3 , 1  ,  1   , 3    , -1    ,  -3   ,   3   ,  3      ;
-3 , 1 , -1 , -3 , -1 , 3  ,  1   , 3    , 3     , 3     , -1    , 1       ;
3  ,-1 , 1  , -3 , -1 , -1 ,   1  ,  1   ,  3    ,  1    ,  -1   ,  -3     ;
1  ,3  ,1   , -1 , 1  ,3   , 3    ,3     ,-1     , -1    ,  3    , -1      ;
-3 , 1 , 1  ,  3 , -3 , 3  ,  -3  ,  -3  ,   3   ,   1   ,   3   ,  -1     ;
-3 , 3 , 1  ,  1 , -3 , 1  ,  -3  ,  -3  ,   -1  ,    -1 ,     1 ,    -3   ;
-1 , 3 , 1  ,  3 , 1  ,-1  ,  -1  ,  3   ,  -3   ,   -1  ,    -3 ,    -1   ;
-1 , -3,  1 ,  1 , 1  ,1   , 3    ,1     ,-1     , 1     , -3    , -1      ;
-1 , 3 , -1 ,  1 , -3 , -3 ,   -3 ,   -3 ,    -3 ,     1 ,     -1,     -3  ;
1  ,1  ,-3  , -3 , -3 , -3 ,   -1 ,   3  ,   -3  ,    1  ,    -3 ,    3    ;
1  ,1  ,-1  , -3 , -1 , -3 ,   1  ,  -1  ,   1   ,   3   ,   -1  ,   1     ;
1  ,1  ,3   ,  1 , 3  ,3   , -1   , 1    , -1    ,  -3   ,   -3  ,   1     ;
1  ,-3 , 3  ,  3 , 1  ,3   , 3    ,1     ,-3     , -1    ,  -1   ,  3      ;
1  ,3  ,-3  , -3 , 3  ,-3  ,  1   , -1   ,  -1   ,   3   ,   -1  ,   -3    ;
-3 , -1, -3 , -1 , -3 , 3  ,  1   , -1   ,  1    ,  3    ,  -3   ,  -3     ;
-1 , 3 , -3 ,  3 , -1 , 3  ,  3   , -3   ,  3    ,  3    ,  -1   ,  -1     ;
3  ,-3 , -3 , -1 , -1 , -3 ,   -1 ,   3  ,   -3  ,    3  ,    1  ,   -1    ];
fai_24sc = [-1,	3,	1,	-3,	3,	-1,	1,	3,	-3,	3,	1,	3,	-3,	3,	1,	1,	-1,	1,	3,	-3,	3,	-3,	-1,	-3;
-3,	3,	-3,	-3,	-3,	1,	-3,	-3,	3,	-1,	1,	1,	1,	3,	1,	-1,	3,	-3,	-3,	1,	3,	1,	1,	-3;
3,	-1,	3,	3,	1,	1,	-3,	3,	3,	3,	3,	1,	-1,	3,	-1,	1,	1,	-1,	-3,	-1,	-1,	1,	3,	3;
-1,	-3,	1,	1,	3,	-3,	1,	1,	-3,	-1,	-1,	1,	3,	1,	3,	1,	-1,	3,	1,	1,	-3,	-1,	-3,	-1;
-1,	-1,	-1,	-3,	-3,	-1,	1,	1,	3,	3,	-1,	3,	-1,	1,	-1,	-3,	1,	-1,	-3,	-3,	1,	-3,	-1,	-1;
-3,	1,	1,	3,	-1,	1,	3,	1,	-3,	1,	-3,	1,	1,	-1,	-1,	3,	-1,	-3,	3,	-3,	-3,	-3,	1,	1;
1,	1,	-1,	-1,	3,	-3,	-3,	3,	-3,	1,	-1,	-1,	1,	-1,	1,	1,	-1,	-3,	-1,	1,	-1,	3,	-1,	-3;
-3,	3,	3,	-1,	-1,	-3,	-1,	3,	1,	3,	1,	3,	1,	1,	-1,	3,	1,	-1,	1,	3,	-3,	-1,	-1,	1;
-3,	1,	3,	-3,	1,	-1,	-3,	3,	-3,	3,	-1,	-1,	-1,	-1,	1,	-3,	-3,	-3,	1,	-3,	-3,	-3,	1,	-3;
1,	1,	-3,	3,	3,	-1,	-3,	-1,	3,	-3,	3,	3,	3,	-1,	1,	1,	-3,	1,	-1,	1,	1,	-3,	1,	1;
-1,	1,	-3,	-3,	3,	-1,	3,	-1,	-1,	-3,	-3,	-3,	-1,	-3,	-3,	1,	-1,	1,	3,	3,	-1,	1,	-1,	3;
1,	3,	3,	-3,	-3,	1,	3,	1,	-1,	-3,	-3,	-3,	3,	3,	-3,	3,	3,	-1,	-3,	3,	-1,	1,	-3,	1;
1,	3,	3,	1,	1,	1,	-1,	-1,	1,	-3,	3,	-1,	1,	1,	-3,	3,	3,	-1,	-3,	3,	-3,	-1,	-3,	-1;
3,	-1,	-1,	-1,	-1,	-3,	-1,	3,	3,	1,	-1,	1,	3,	3,	3,	-1,	1,	1,	-3,	1,	3,	-1,	-3,	3;
-3,	-3,	3,	1,	3,	1,	-3,	3,	1,	3,	1,	1,	3,	3,	-1,	-1,	-3,	1,	-3,	-1,	3,	1,	1,	3;
-1,	-1,	1,	-3,	1,	3,	-3,	1,	-1,	-3,	-1,	3,	1,	3,	1,	-1,	-3,	-3,	-1,	-1,	-3,	-3,	-3,	-1;
-1,	-3,	3,	-1,	-1,	-1,	-1,	1,	1,	-3,	3,	1,	3,	3,	1,	-1,	1,	-3,	1,	-3,	1,	1,	-3,	-1;
1,	3,	-1,	3,	3,	-1,	-3,	1,	-1,	-3,	3,	3,	3,	-1,	1,	1,	3,	-1,	-3,	-1,	3,	-1,	-1,	-1;
1,	1,	1,	1,	1,	-1,	3,	-1,	-3,	1,	1,	3,	-3,	1,	-3,	-1,	1,	1,	-3,	-3,	3,	1,	1,	-3;
1,	3,	3,	1,	-1,	-3,	3,	-1,	3,	3,	3,	-3,	1,	-1,	1,	-1,	-3,	-1,	1,	3,	-1,	3,	-3,	-3;
-1,	-3,	3,	-3,	-3,	-3,	-1,	-1,	-3,	-1,	-3,	3,	1,	3,	-3,	-1,	3,	-1,	1,	-1,	3,	-3,	1,	-1;
-3,	-3,	1,	1,	-1,	1,	-1,	1,	-1,	3,	1,	-3,	-1,	1,	-1,	1,	-1,	-1,	3,	3,	-3,	-1,	1,	-3;
-3,	-1,	-3,	3,	1,	-1,	-3,	-1,	-3,	-3,	3,	-3,	3,	-3,	-1,	1,	3,	1,	-3,	1,	3,	3,	-1,	-3;
-1,	-1,	-1,	-1,	3,	3,	3,	1,	3,	3,	-3,	1,	3,	-1,	3,	-1,	3,	3,	-3,	3,	1,	-1,	3,	3;
1,	-1,	3,	3,	-1,	-3,	3,	-3,	-1,	-1,	3,	-1,	3,	-1,	-1,	1,	1,	1,	1,	-1,	-1,	-3,	-1,	3;
1,	-1,	1,	-1,	3,	-1,	3,	1,	1,	-1,	-1,	-3,	1,	1,	-3,	1,	3,	-3,	1,	1,	-3,	-3,	-1,	-1;
-3,	-1,	1,	3,	1,	1,	-3,	-1,	-1,	-3,	3,	-3,	3,	1,	-3,	3,	-3,	1,	-1,	1,	-3,	1,	1,	1;
-1,	-3,	3,	3,	1,	1,	3,	-1,	-3,	-1,	-1,	-1,	3,	1,	-3,	-3,	-1,	3,	-3,	-1,	-3,	-1,	-3,	-1;
-1,	-3,	-1,	-1,	1,	-3,	-1,	-1,	1,	-1,	-3,	1,	1,	-3,	1,	-3,	-3,	3,	1,	1,	-1,	3,	-1,	-1;
1,	1,	-1,	-1,	-3,	-1,	3,	-1,	3,	-1,	1,	3,	1,	-1,	3,	1,	3,	-3,	-3,	1,	-1,	-1,	1,	3 ];

%确定组号u的具体取值；
if(group_hop_flag == 0)  %组跳频无效
    fghns = 0;
else
    cinit=floor(cellid/30);
    cgroup = pseudo_random_seq_gen(cinit,180);
    sum=0;
    for(iii=0:7)
        sum = sum+cgroup(8*slotno+iii+1)*(2^iii);
    end
    fghns = mod(sum,30);
end
fss = mod(cellid,30);
fss = mod((fss+deltass),30);
u=mod(fghns+fss,30);
    
%确定组内序列号v的具体取值；
if(rbnum<6)
    v=0;
elseif(group_hop_flag == 0) & (seq_hop_flag == 1) 
    cinit=floor(cellid/30)*32+fss;    
    cseq = pseudo_random_seq_gen(cinit,180);
    v= cseq(slotno);   
else
    v=0;
end

%基本序列生成
mrssc = rbnum*12;
if(rbnum==1)  %序列长度为12个子载波
    for(iii=1:mrssc)
        ruvns(iii) = exp(j*pi/4*fai_12sc((u+1),iii)); %
    end
elseif(rbnum==2)  %序列长度为24个子载波
    for(iii=1:mrssc)
        ruvns(iii) = exp(j*pi/4*fai_24sc((u+1),iii)); % 
    end
else %序列长度大于等于36个子载波。    
    nrszc = prime_table(rbnum);  %by maoxuewei @2090324
    qs = nrszc*(u+1)/31;
    q= floor(qs+0.5)+v*((-1)^(floor(2*qs)));
    for(iii=1:nrszc)
        xqm(iii) = exp(-j*pi*q*(iii-1)*iii/nrszc);
    end
    for(iii=1:mrssc)
        ruvns(iii) = xqm(mod((iii-1),nrszc)+1);
    end
end

basic_out = ruvns;
%计算a的值,并得到最后的序列
cinit=floor(cellid/30)*32+fss;    
cseq = pseudo_random_seq_gen(cinit,1120); % based on 3GPP 36211-850 
nprs = 0;
for(iii=0:7)
    nprs = nprs+cseq(slotno*8*7+iii+1)*(2^iii);
end

ncs=mod(ndmrs1+ndmrs2_table(cyc_shift+1)+nprs,12);
alpha = 2*pi*ncs/12;
for(iii=0:mrssc-1)
    temp1 = exp(j*iii*alpha);
    out(iii+1) = temp1*ruvns(iii+1);
end


return;
    
    