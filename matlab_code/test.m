recv_len = 30720;
pcip = '192.168.1.181';
xsrpip='192.168.1.167';
type = 1;



fs = 30720;
dt = 1/fs;
t = 0:dt:1-dt;
txdataI = sin(2*pi*10*t);
txdataQ = cos(2*pi*10*t);
divFreq = 5;
txdataIQ = txdataI+txdataQ*i;
[rxdataIQ,message] = XSRP_RFLoopback(txdataIQ,divFreq,recv_len,pcip,xsrpip,type);

figure(1)
subplot(211)
plot(real(rxdataIQ))
subplot(212)
plot(imag(rxdataIQ))