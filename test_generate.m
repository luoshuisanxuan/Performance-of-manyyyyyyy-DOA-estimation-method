% 生成变量（信噪比/阵列个数/……）分集的测试集：修改VariableARR和参与循环的变量名
% test_set.mat
%      -theta_test（训练样本的入射角）: {1,2,3} x sample double（目标数 x 样本数）
%      -Signal_eta（训练输入特征）: sample x 181 double（样本数 x 输入向量）
%      -estCBF（CBF算法检测的入射角）: variable x 2 x sample double （分集 x 目标数 x 样本数）
%      -estCapon（Capon算法检测的入射角）: variable x 2 x sample double （分集 x 目标数 x 样本数）
%      -estMUSIC（MUSIC算法检测的入射角）: variable x 2 x sample double （分集 x 目标数 x 样本数）
%      -estESPRIT（ESPRIT算法检测的入射角）: variable x 2 x sample double （分集 x 目标数 x 样本数）
%      -estOMP（OMP算法检测的入射角）: variable x 2 x sample double （分集 x 目标数 x 样本数）

clc; clear; close all;
dd = 0.5;               % space 
numSignal = 2;          % number of DOA
phi_start = -90;        % 定义角区间起点
phi_end = 90;           % 定义角区间终点
Phi = phi_start:1:phi_end; % 定义角区间
P = length(Phi);        % 定义角度数=180

%% 设置测试信号基本参数及默认参数
snr = 0;         % 默认信噪比
sample = 500;    % 产生n个测试样本:建议100-500
kelm = 8;         % 默认阵列数量
snapshot = 256;     % 默认快拍数量
theta_test = zeros(numSignal, sample); % 用于保存入射角度

%% 随机产生两个角度
for iTheta = 1:sample
    theta1 = randi([-60,60]);
    theta2 = randi([-60,60]);
    theta_test(:,iTheta) = [theta1;theta2];
end

%% 产生空间谱并保存
VariableARR = -10:30; %SNR 如果是阵元数则VariableARR = 2:2:16;
Signal_eta = zeros(length(VariableARR),sample,P);
estCBF = zeros(length(VariableARR),numSignal,sample);
estCapon = zeros(length(VariableARR),numSignal,sample);
estMUSIC = zeros(length(VariableARR),numSignal,sample);
estESPRIT = zeros(length(VariableARR),numSignal,sample);
estOMP = zeros(length(VariableARR),numSignal,sample);
iVariable = 0;
% for kelm = VariableARR %更换变量需改变量名 
for snr = VariableARR
    iVariable = iVariable+1;
    for iSample = 1:sample     
        thetaOneTest = theta_test(:,iSample)';
        Signal = randn(numSignal,snapshot);
        A = exp(-1j*2*pi*(0:kelm-1)'*dd*sind(thetaOneTest));% 导向矩阵
        X = A*Signal;
        X = awgn(X,snr,'measured');   
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

        
        %% 保存数据
        estCBF(iVariable,:,iSample) = getPeak(P_CBF,numSignal);% 谱峰搜索并保存空间普峰值下标  
        estCapon(iVariable,:,iSample) = getPeak(P_Capon,numSignal);
        estMUSIC(iVariable,:,iSample) = getPeak(P_MUSIC,numSignal);    
        estESPRIT(iVariable,:,iSample) = P_ESPRIT;  
        estOMP(iVariable,:,iSample) = P_OMP;
        Signal_eta(iVariable,iSample,:) = P_MUSIC ;                  % 保存CNN的测试集特征     
    end
end
save('test_set.mat','theta_test','estCBF','estCapon','estMUSIC','estESPRIT',...
'estOMP','VariableARR','Signal_eta');





