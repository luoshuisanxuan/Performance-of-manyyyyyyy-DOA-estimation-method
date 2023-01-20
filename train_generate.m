% ����ѵ������
% traning_set.mat
% theta_train��ѵ������������ǣ�: 2 x ____ double��Ŀ���� x ��������
% Signal_eta������������: ____ x 181 double �������� x ����������
% Signal_label��ѵ����ǩ��: 2 x ____ double ��Ŀ���� x ��������

%%ģ�ͻ�������
dd = 0.5;            % ��Ԫ��ನ����
numSignal = 2;       % number of DOA           
kelm = 8;            % ��Ԫ�� 
snapshot = 128;      % ������
phi_start = -90;     % ������������
phi_end = 90;        % ����������յ�
Phi = phi_start:phi_end; % �����Ƕ�
P = length(Phi);     % ����Ƕ���=180
nsample = 90000;     % ������ 5w~10w

%% ����theta_train  
theta1=[];theta2=[];
for iTheta = 1:nsample
    theta1 = [theta1,randi([-60,60])];
    theta2 = [theta2,randi([-60,60])];
end
theta_train = [theta1;theta2];

%% ����Signal_eta��Signal_label
Signal_eta = zeros(length(theta_train),P);
Signal_label = zeros(length(theta_train),P);
for iThetaTrain = 1:length(theta_train)      % ����ÿ��ѵ������
    S0 = randn(numSignal,snapshot); 
    A = exp(-1j*2*pi*(0:kelm-1)'*dd*sind(theta_train(:,iThetaTrain)')); % �������
    X = A*S0;
    X1 = awgn(X,randi([-10,30]),'measured');    % ��[-10:30]dB������  
    Signal_eta(iThetaTrain,:) = music_doa(X1,numSignal,dd,Phi);  % �� MUSIC-DOA����
    Signal_label(iThetaTrain,round(theta_train(:,iThetaTrain))+91) = ones(1,numSignal);   % �����źű�ǩΪ 1 
end

%% ����ѵ������
save('train_set.mat','theta_train','Signal_label','Signal_eta');

%% �鿴����
load('train_set.mat','theta_train','Signal_label','Signal_eta');
iSample = floor(rand * length(theta_train));   
plot(Phi,Signal_eta(iSample,:));hold on;
stem(find(Signal_label(iSample,:)==1)-91,ones(1,numSignal))
grid on;xlim([-90,90]); ylim([-1.1,1.1]);xlabel('�Ƕ�(��)');
legend('\bf\it{\eta}','\bf\it{y}');hold off;
