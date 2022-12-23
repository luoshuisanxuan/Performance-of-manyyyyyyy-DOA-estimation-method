% ���ɱ����������/���и���/�������ּ��Ĳ��Լ����޸�VariableARR�Ͳ���ѭ���ı�����
% test_set.mat
%      -theta_test��ѵ������������ǣ�: {1,2,3} x sample double��Ŀ���� x ��������
%      -Signal_eta��ѵ������������: sample x 181 double�������� x ����������
%      -estCBF��CBF�㷨��������ǣ�: variable x 2 x sample double ���ּ� x Ŀ���� x ��������
%      -estCapon��Capon�㷨��������ǣ�: variable x 2 x sample double ���ּ� x Ŀ���� x ��������
%      -estMUSIC��MUSIC�㷨��������ǣ�: variable x 2 x sample double ���ּ� x Ŀ���� x ��������
%      -estESPRIT��ESPRIT�㷨��������ǣ�: variable x 2 x sample double ���ּ� x Ŀ���� x ��������
%      -estOMP��OMP�㷨��������ǣ�: variable x 2 x sample double ���ּ� x Ŀ���� x ��������

clc; clear; close all;
dd = 0.5;               % space 
numSignal = 2;          % number of DOA
phi_start = -90;        % ������������
phi_end = 90;           % ����������յ�
Phi = phi_start:1:phi_end; % ���������
P = length(Phi);        % ����Ƕ���=180

%% ���ò����źŻ���������Ĭ�ϲ���
snr = 0;         % Ĭ�������
sample = 500;    % ����n����������:����100-500
kelm = 8;         % Ĭ����������
snapshot = 256;     % Ĭ�Ͽ�������
theta_test = zeros(numSignal, sample); % ���ڱ�������Ƕ�

%% ������������Ƕ�
for iTheta = 1:sample
    theta1 = randi([-60,60]);
    theta2 = randi([-60,60]);
    theta_test(:,iTheta) = [theta1;theta2];
end

%% �����ռ��ײ�����
VariableARR = -10:30; %SNR �������Ԫ����VariableARR = 2:2:16;
Signal_eta = zeros(length(VariableARR),sample,P);
estCBF = zeros(length(VariableARR),numSignal,sample);
estCapon = zeros(length(VariableARR),numSignal,sample);
estMUSIC = zeros(length(VariableARR),numSignal,sample);
estESPRIT = zeros(length(VariableARR),numSignal,sample);
estOMP = zeros(length(VariableARR),numSignal,sample);
iVariable = 0;
% for kelm = VariableARR %����������ı����� 
for snr = VariableARR
    iVariable = iVariable+1;
    for iSample = 1:sample     
        thetaOneTest = theta_test(:,iSample)';
        Signal = randn(numSignal,snapshot);
        A = exp(-1j*2*pi*(0:kelm-1)'*dd*sind(thetaOneTest));% �������
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

        
        %% ��������
        estCBF(iVariable,:,iSample) = getPeak(P_CBF,numSignal);% �׷�����������ռ��շ�ֵ�±�  
        estCapon(iVariable,:,iSample) = getPeak(P_Capon,numSignal);
        estMUSIC(iVariable,:,iSample) = getPeak(P_MUSIC,numSignal);    
        estESPRIT(iVariable,:,iSample) = P_ESPRIT;  
        estOMP(iVariable,:,iSample) = P_OMP;
        Signal_eta(iVariable,iSample,:) = P_MUSIC ;                  % ����CNN�Ĳ��Լ�����     
    end
end
save('test_set.mat','theta_test','estCBF','estCapon','estMUSIC','estESPRIT',...
'estOMP','VariableARR','Signal_eta');





