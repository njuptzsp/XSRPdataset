function rxSig = OFDM_awgn(txSig,snr)

rxSig = awgn(txSig,snr,'measured');

end
