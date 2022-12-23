% 将CNN的预测结果与CBF/Capon/MUSIC/ESPRIT/OMP/作比较
clear;clc;close all;
load('cnn_predict_OneTest.mat','P_cnn');
load('OneTestSet.mat','thetaOneTest','Signal_label','Signal_eta','Phi'...
,'P_CBF','P_Capon','P_MUSIC','P_ESPRIT','P_OMP');

plot(Phi,P_CBF);hold on
plot(Phi,P_Capon);
plot(Phi,P_MUSIC);
stem(P_ESPRIT,ones(1,length(P_ESPRIT)),'d');
stem(P_OMP,ones(1,length(P_OMP)),'filled');
plot(Phi,P_cnn);hold off
legend('CBF','Capon','MUSIC','ESPRIT','OMP','CNN');grid on;
