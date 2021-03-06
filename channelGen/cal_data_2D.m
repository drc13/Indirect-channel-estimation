%% Definition of parameters
N_Scatter = 10;
N_SBS = 5;
N_MS = 2000;    % MS number
M = 200; %MBS antenna number

SBS_locations = zeros(N_SBS,2);
Scatter_locations = zeros(N_Scatter,2);
MS_locations = zeros(N_MS,2);
K = 10;      % LOS factor, sqrt(K_Rician) = gamma/(1-gamma)

frequency = 2.4e9;
opt.frequency = frequency;
opt.K = K;
lamda = 3e8/frequency;
D = lamda*0.5;  % distance between antenna elements of MBS

H_MBS = zeros(N_MS,M);  % channel impulse responses of MBS
H_SBS = zeros(N_MS,N_SBS);  % channel impulse responses of SBS

%% Generate scatterer location
for i = 1:N_Scatter
    r_Scatter = 700*rand;
    phi_Scatter = rand*pi;
    Scatter_locations(i,1) = r_Scatter*cos(phi_Scatter);
    Scatter_locations(i,2) = r_Scatter*sin(phi_Scatter);  
end

%% Generate SBS locations
SBS_locations = [-200,500;200,500;-500,200;0,200;500,200];

% % generate random locations
% for i = 1:N_SBS
%     r_SBS = 500*rand;
%     phi_SBS = pi*rand;
%     SBS_locations(i,1) = r_SBS*cos(phi_SBS);
%     SBS_locations(i,2) = r_SBS*sin(phi_SBS);
% end


%% Calulate channel responses from different MS
for i_MS = 1:N_MS
    while(1)
        MS_locations(i_MS,1) = 1400*(rand-0.5);
        MS_locations(i_MS,2) = 700*rand;
        if(norm(MS_locations(i_MS,:))<=700)
            break;
        end
    end
    % calculate responses of MBS antennas
    H1 = zeros(M,1);
    H2 = zeros(M,1);
    for m = 1:M
        [H_MBS(i_MS,m)] = h_cal(MS_locations(i_MS,:),[(m-1)*D,0],Scatter_locations,opt);
    end
    % calculate responses of SBS antennas
    for i_SBS = 1:N_SBS
       [H_SBS(i_MS,i_SBS)] = h_cal(MS_locations(i_MS,:),SBS_locations(i_SBS,:),Scatter_locations,opt); 
    end
end
%% Figures
% figure(1);
% scatter3(Scatter_locations(:,1),Scatter_locations(:,2),Scatter_locations(:,3),'b.');
% hold on;
% scatter3(SBS_locations(:,1),SBS_locations(:,2),SBS_locations(:,3),'rs');
% hold on;
% %plot3(MS_locations(:,1),MS_locations(:,2),MS_locations(:,3),'rv');
% plot3(0,0,0,'rs','MarkerFaceColor','r');
% hold off;
% % show amplitudes and phases of H_MBS(1,:) and H_SBS(1,:)
% figure(2);
% subplot(1,2,1);plot(abs(H_MBS(1,:)));title('amplitude');
% subplot(1,2,2);plot(unwrap(angle(H_MBS(1,:))));title('phase');
% figure(3);
% subplot(1,2,1);plot(abs(H_SBS(1,:)));title('amplitude');
% subplot(1,2,2);plot(unwrap(angle(H_SBS(1,:))));title('phase');
%% Data saving
save(['2D_data_with_',num2str(M),'_antennas_fixed2_SBSs_',num2str(N_Scatter),'_scatterers.mat'],'N_Scatter','N_SBS','N_MS','SBS_locations','Scatter_locations','MS_locations','H_MBS','H_SBS');