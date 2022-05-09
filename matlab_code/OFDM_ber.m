function [errnum,ber] = OFDM_ber(txbit,rxbit)

errnum = sum(xor(txbit,rxbit));
len = length(txbit);
ber = errnum/len;

end