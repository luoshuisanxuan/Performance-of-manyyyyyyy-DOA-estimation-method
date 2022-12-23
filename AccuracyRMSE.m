% ����׼ȷ�ʺ;��������
% ��CNN��Ԥ������CBF/Capon/MUSIC/ESPRIT/OMP���Ƚ�
clear;clc;close all
load('test_set.mat','theta_test','estCBF','estCapon','estMUSIC','estESPRIT',...
'estOMP','VariableARR','Signal_eta');
nLevel = size(estMUSIC,1);     % �ּ��ĸ�����snr������/����Ԫ����������ȣ�
nSignal = size(estMUSIC,2);    % ��Դ����
nsample = size(estMUSIC,3);    % ÿ��������������
threshold = 1;                  % ��Ϊ������ȷ������

%% ����׼ȷ������������
[probCBF,rmseCBF] = ShotOrNot(estCBF,theta_test,threshold);  
[probCapon,rmseCapon] = ShotOrNot(estCBF,theta_test,threshold);
[probMUSIC,rmseMUSIC] = ShotOrNot(estMUSIC,theta_test,threshold);  
[probESPRIT,rmseESPRIT] = ShotOrNot(estESPRIT,theta_test,threshold);
[probOMP,rmseOMP] = ShotOrNot(estOMP,theta_test,threshold);  
%% ����CNN��Ԥ����
load('cnn_predict','estCNN');
estCnn = zeros(nLevel,nSignal,nsample);
for iLevel = 1:nLevel
    for iSample = 1:nsample
        cnn_doa_one = reshape(estCNN(iLevel,iSample,:),181,1);
        estCnn(iLevel,:,iSample) = getPeak(cnn_doa_one,2);     % CNN�����׵��׷�����
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
xlabel('SNR(dB)');ylabel('DOA����׼ȷ��')
legend('CBF','Capon','MUSIC','ESPRIT','OMP','CNN');
title("Change of SNR");

figure;
plot(VariableARR,rmseCBF,'-s','Linewidth',Linewidth);hold on;
plot(VariableARR,rmseCapon,'-o','Linewidth',Linewidth);
plot(VariableARR,rmseMUSIC,'--','Linewidth',Linewidth);
plot(VariableARR,rmseESPRIT,'.-','Linewidth',Linewidth);
plot(VariableARR,rmseOMP,'-d','Linewidth',Linewidth);grid on;
plot(VariableARR,rmseCNN,':','Linewidth',Linewidth);hold off;
xlabel('SNR(dB)');ylabel('RMSE(��)')
legend('CBF','Capon','MUSIC','ESPRIT','OMP','CNN');
title("Change of SNR");

