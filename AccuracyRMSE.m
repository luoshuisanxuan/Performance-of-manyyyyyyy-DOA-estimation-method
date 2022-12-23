% 分析准确率和均方根误差
% 将CNN的预测结果与CBF/Capon/MUSIC/ESPRIT/OMP作比较
clear;clc;close all
load('test_set.mat','theta_test','estCBF','estCapon','estMUSIC','estESPRIT',...
'estOMP','VariableARR','Signal_eta');
nLevel = size(estMUSIC,1);     % 分集的个数（snr的种类/阵列元个数的种类等）
nSignal = size(estMUSIC,2);    % 信源个数
nsample = size(estMUSIC,3);    % 每个集的样本个数
threshold = 1;                  % 认为估计正确的门限

%% 估计准确率与均方根误差
[probCBF,rmseCBF] = ShotOrNot(estCBF,theta_test,threshold);  
[probCapon,rmseCapon] = ShotOrNot(estCBF,theta_test,threshold);
[probMUSIC,rmseMUSIC] = ShotOrNot(estMUSIC,theta_test,threshold);  
[probESPRIT,rmseESPRIT] = ShotOrNot(estESPRIT,theta_test,threshold);
[probOMP,rmseOMP] = ShotOrNot(estOMP,theta_test,threshold);  
%% 加载CNN的预测结果
load('cnn_predict','estCNN');
estCnn = zeros(nLevel,nSignal,nsample);
for iLevel = 1:nLevel
    for iSample = 1:nsample
        cnn_doa_one = reshape(estCNN(iLevel,iSample,:),181,1);
        estCnn(iLevel,:,iSample) = getPeak(cnn_doa_one,2);     % CNN特征谱的谱峰搜索
    end
end
[probCNN,rmseCNN] = ShotOrNot(estCnn,theta_test,threshold); 


Linewidth = 1.5;
figure;
plot(VariableARR,probCBF,'-s','Linewidth',Linewidth);hold on;
plot(VariableARR,probCapon,'-o','Linewidth',Linewidth);
plot(VariableARR,probMUSIC,'--','Linewidth',Linewidth);
plot(VariableARR,probESPRIT,'.-','Linewidth',Linewidth);
plot(VariableARR,probOMP,'-d','Linewidth',Linewidth);grid on;
plot(VariableARR,probCNN,':','Linewidth',Linewidth);hold off
xlabel('SNR(dB)');ylabel('DOA估计准确率')
legend('CBF','Capon','MUSIC','ESPRIT','OMP','CNN');
title("Change of SNR");

figure;
plot(VariableARR,rmseCBF,'-s','Linewidth',Linewidth);hold on;
plot(VariableARR,rmseCapon,'-o','Linewidth',Linewidth);
plot(VariableARR,rmseMUSIC,'--','Linewidth',Linewidth);
plot(VariableARR,rmseESPRIT,'.-','Linewidth',Linewidth);
plot(VariableARR,rmseOMP,'-d','Linewidth',Linewidth);grid on;
plot(VariableARR,rmseCNN,':','Linewidth',Linewidth);hold off;
xlabel('SNR(dB)');ylabel('RMSE(°)')
legend('CBF','Capon','MUSIC','ESPRIT','OMP','CNN');
title("Change of SNR");

