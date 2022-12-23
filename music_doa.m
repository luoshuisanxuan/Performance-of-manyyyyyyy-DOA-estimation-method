    function P_MUSIC = music_doa(X, numSignal, dd, Theta)
    % P_MUSIC：MUSIC-DOA估计谱
    % x:阵列接收信号
    % numSignal:信号源数
    % dd:阵元间距波长比
    % Theta:遍历角度
        P_MUSIC = [];
        L = size(X,2);
        kelm = size(X,1);
        R = X*X'/L;
        [Evetor,~] = eig(R);
        Un = Evetor(:,1:kelm-numSignal);
        for i = 1:length(Theta) 
             a_theta = exp(-1j*2*pi*dd*(0:kelm-1)'*sind(Theta(i))); 
             P_MUSIC(i) = abs((a_theta)'*Un*Un'*a_theta)^(-1);    
        end
        logP0 = log10(P_MUSIC/max(P_MUSIC));
        P_MUSIC = (logP0-min(logP0))/max(logP0-min(logP0)); % 归一化
    end
    
    