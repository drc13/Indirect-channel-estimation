% Preprocess GSCM Simulation Data
load('./gscm_data2/data_with_80antennas.mat');  % Load from dataset
% X = [real(H_MBS),imag(H_MBS)];                  % Cat. real and imag parts as a long matrix
X = abs(fft(H_MBS,[],2));
[~,y] = max(abs(H_SBS),[],2);                   % Connect to the SBS with largest SNR
save('gscm_data2.mat','X','y');                 % Save to file