% 将CNN的预测结果与CBF/Capon/MUSIC/ESPRIT/OMP/SBL作比较
% C:\Users\HUANG.CHU.HAN\Desktop\SU\阵列大作业\photo
clear;clc;close all;
load('cnn_predict_OneTest.mat','P_cnn');
load('OneTestSet.mat','thetaOneTest','Signal_label','Signal_eta','Phi'...
,'P_CBF','P_Capon','P_MUSIC','P_ESPRIT','P_OMP','P_SBL');

Linewidth = 1.5;
plot(Phi,P_CBF,':','Linewidth',Linewidth);hold on
% plot(Phi,P_Capon,'--','Linewidth',Linewidth);hold on
plot(Phi,P_MUSIC,'.-','Linewidth',Linewidth);
% stem(P_ESPRIT,ones(1,length(P_ESPRIT)));hold on
stem(P_OMP,ones(1,length(P_OMP)),'filled');
stem(P_SBL,ones(1,length(P_SBL)),'d');
% plot(Phi,P_cnn,'-','Linewidth',Linewidth);hold off
legend('CBF','MUSIC','OMP','SBL');grid on;
grid on;
% legend('Capon','MUSIC','SBL')
% legend('ESPRIT','OMP','SBL')