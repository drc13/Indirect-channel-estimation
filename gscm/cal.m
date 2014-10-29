%% Calculate Channel Matrix
%  Takes location of MS, scatter as input
%  Assume MBS is ULA, first unit at origin [0,0,0], streching toward +z direction
% #####
% 1. long distance approx. for ULA hold?
% 2. Channel normalization, summerizing to overall channel
%% Initialization
M = 1000;             % Num of MBS antenna
f = 2.4e9;          % Carrier freq
lamda = 3e8/f;      % Wave length
D = lamda*0.5;      % Antenna unit spacing (half lambda)
gamma = 0;        % LOS factor, K_Rician = sqrt(gamma/(1-gamm))

%% Calculate channel response
H  = zeros(1,M);    % Overall channel matrix
H1 = zeros(1,M);    % LOS component
H2 = zeros(1,M);    % Single scattering component
for m = 1:M
% Loop through MBS antennas
    d0 = norm([x_MS,y_MS,z_MS]);  % Distance from MS and MBS
    % LOS component
    H1(m) = lamda/(4*pi*d0)*...    
             exp(1j*2*pi*d0/lamda)*...
             exp(-1j*2*pi/lamda*(m-1)*D*x_MS/d0);
%              exp(-1j*2*pi/lamda*(m-1)*D*z_MS/d0);  
    for i = 1:N_MSscatter
    % Loop through Scatters
        d1 = norm([x_MS-x_MSscatter(i),y_MS-y_MSscatter(i),z_MS-z_MSscatter(i)]); % Distance from MS and scatterer
        d2 = norm([x_MSscatter(i),y_MSscatter(i),z_MSscatter(i)]);                % Distance from scatterer to MBS
        % Summing up scattering component
        H2(m) = H2(m) + lamda/(4*pi*(d1+d2))*...
                 exp(1j*2*pi*(d1+d2)/lamda)*...
                 exp(-1j*2*pi/lamda*(m-1)*D*x_MSscatter(i)/d2);
%                  exp(-1j*2*pi/lamda*(m-1)*D*z_MSscatter(i)/d2);
    end    
%     H(m) = gamma*H1(m)/abs(H1(m)) + (1-gamma)*H2(m)/abs(H2(m));    
end
% Overall channel
power_H1 = mean(H1.*conj(H1));    % Power of LOS component
power_H2 = mean(H2.*conj(H2));    % Power of scattering component
H = gamma*H1/sqrt(power_H1) + (1-gamma)*H2/sqrt(power_H2);
%% Visualization
figure(1);
subplot(1,2,1);plot(abs(H));title('amplitude');
subplot(1,2,2);plot(unwrap(angle(H))/pi*180);title('phase');
% figure(2);
% subplot(1,2,1);plot(abs(G));title('amplitude');
% subplot(1,2,2);plot(angle(G));title('phase');