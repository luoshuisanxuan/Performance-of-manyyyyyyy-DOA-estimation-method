% 生成单个测试样本：
% OneTestSet.mat
%      -thetaOneTest（样本的入射角）: {1,2,3,4} x 1 double
%      -Signal_eta（训练输入特征）: 1 x 181 double
%      -Signal_label（训练标签）: 1 x 181 double
%      -Phi （遍历角度）：1×181 double
%      -P_CBF (CBF算法的空间谱) ：1×181 double
%      -P_Capon （Capon的空间谱）: 1×181 double
%      -P_MUSIC (MUSIC算法的空间谱) ：1×181 double
%      -P_ESPRIT （ESPRIT的空间谱）: 1×181 double
%      -P_OMP (OMP算法的空间谱) ：{1,2,3,4} x 1 double


clc; clear; close all;warning off
%%模型基本参数
dd = 0.5;               % 阵元间距波长比
snr = 20;               % input SNR (dB)
kelm = 8;               % 阵元数=8
snapshot = 128;         % 快拍数
phi_start = -90;        % 定义角区间起点
phi_end = 90;           % 定义角区间终点
Phi = phi_start:phi_end; % 定义叫区间
P = length(Phi);         % 定义角度数=180

%% 产生theta_train
thetaOneTest = [-20 0 40];          %信号角度  
numSignal = length(thetaOneTest);   % 信号源数

%% 产生Signal_eta和Signal_label
Signal_eta = zeros(1,P);
Signal_label = zeros(1,P);
Signal = randn(numSignal,snapshot);
A = exp(-1j*2*pi*(0:kelm-1)'*dd*sind(thetaOneTest));% 导向矩阵
X = A*Signal;
X = awgn(X,snr,'measured');    
Signal_eta = Signal_eta + music_doa(X,numSignal,dd,Phi);
Signal_label(round(thetaOneTest)+91) = ones(1,length(thetaOneTest));

%% DOA Estimation
P_CBF = cbf_doa(X,numSignal,dd,Phi);        % CBF_DOA
P_Capon = capon_doa(X,numSignal,dd,Phi);    % Capon_DOA
P_MUSIC = music_doa(X,numSignal,dd,Phi);    % MUSIC_DOA

BigPhi = diag(exp(1j*2*pi*dd*sind(thetaOneTest)));
AMat = exp(-1j*2*pi*dd*(0:kelm-1)'*sind(thetaOneTest)); % Direction Matrix 
AMatPro = [AMat;AMat*BigPhi];
X_ESPRIT = awgn(AMatPro*Signal,snr);
P_ESPRIT = esprit_doa(X_ESPRIT,numSignal,dd,Phi);   % ESPRIT_DOA

Signal_OMP = zeros(length(Phi),snapshot);           % OMP_DOA
for i = 1:length(thetaOneTest)
    theta_ind = find(Phi==thetaOneTest(i));
    Signal_OMP(theta_ind,:) = randn(1,snapshot);
end
A_OMP = exp(-1j*2*pi*(0:kelm-1)'*dd*sind(Phi));
X_OMP = awgn(A_OMP*Signal_OMP,snr,'measured');
P_OMP = omp_doa(X_OMP,numSignal,dd,Phi);       


save('OneTestSet.mat','thetaOneTest','Signal_label','Signal_eta','Phi'...
,'P_CBF','P_Capon','P_MUSIC','P_ESPRIT','P_OMP');
%% 查看样本   
plot(Phi,Signal_eta,'LineWidth',1);
hold on;grid on;
stem(find(Signal_label==1)-91,ones(1,length(thetaOneTest)));
% stem(find(Signal_label==2)-91,2*ones(1,length(thetaSpoof)),'filled')
xlim([-90,90]); ylim([-0.1,1.1]);
xlabel('角度(°)');legend('\eta','DOAs');hold off;
