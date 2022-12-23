  function P_Capon = capon_doa(X, numSignal, dd, Theta)
    % P_Capon：Capon-DOA估计谱
    % x:阵列接收信号
    % numSignal:信号源数
    % dd:阵元间距波长比
    % Theta:遍历角度
        L = size(X,2);
        kelm = size(X,1);
        R = X*X'/L;
        P_Capon = zeros(1,length(Theta));
        for i = 1:length(Theta) 
             a_vetor = exp(-1j*2*pi*dd*(0:kelm-1)'*sind(Theta(i)));       
             P_Capon(i) = abs((a_vetor'*R^(-1)*a_vetor)^(-1)); 
        end
        logP0 = log10(P_Capon/max(P_Capon));
        P_Capon = (logP0-min(logP0))/max(logP0-min(logP0)); % 归一化
    end