% 生成训练集：
% traning_set.mat
% theta_train（训练样本的入射角）: 2 x ____ double（目标数 x 样本数）
% Signal_eta（输入特征）: ____ x 181 double （样本数 x 输入向量）
% Signal_label（训练标签）: 2 x ____ double （目标数 x 样本数）

%%模型基本参数
dd = 0.5;            % 阵元间距波长比
numSignal = 2;       % number of DOA           
kelm = 8;            % 阵元数 
snapshot = 128;      % 快拍数
phi_start = -90;     % 定义角区间起点
phi_end = 90;        % 定义角区间终点
Phi = phi_start:phi_end; % 遍历角度
P = length(Phi);     % 定义角度数=180
nsample = 90000;     % 样本数 5w~10w

%% 产生theta_train  
theta1=[];theta2=[];
for iTheta = 1:nsample
    theta1 = [theta1,randi([-60,60])];
    theta2 = [theta2,randi([-60,60])];
end
theta_train = [theta1;theta2];

%% 产生Signal_eta和Signal_label
Signal_eta = zeros(length(theta_train),P);
Signal_label = zeros(length(theta_train),P);
for iThetaTrain = 1:length(theta_train)      % 对于每个训练样本
    S0 = randn(numSignal,snapshot); 
    A = exp(-1j*2*pi*(0:kelm-1)'*dd*sind(theta_train(:,iThetaTrain)')); % 导向矩阵
    X = A*S0;
    X1 = awgn(X,randi([-10,30]),'measured');    % 加[-10:30]dB的噪声  
    Signal_eta(iThetaTrain,:) = music_doa(X1,numSignal,dd,Phi);  % 做 MUSIC-DOA估计
    Signal_label(iThetaTrain,round(theta_train(:,iThetaTrain))+91) = ones(1,numSignal);   % 入射信号标签为 1 
end

%% 保存训练集合
save('train_set.mat','theta_train','Signal_label','Signal_eta');

%% 查看样本
load('train_set.mat','theta_train','Signal_label','Signal_eta');
iSample = floor(rand * length(theta_train));   
plot(Phi,Signal_eta(iSample,:));hold on;
stem(find(Signal_label(iSample,:)==1)-91,ones(1,numSignal))
grid on;xlim([-90,90]); ylim([-1.1,1.1]);xlabel('角度(°)');
legend('\bf\it{\eta}','\bf\it{y}');hold off;
