    function P_CBF = cbf_doa(X, numSignal, dd, Theta)
    % P_CBF：CBF-DOA估计谱
    % x:阵列接收信号
    % numSignal:信号源数(这个函数用不上，保持一致性)
    % dd:阵元间距波长比
    % Theta:遍历角度
        kelm = size(X,1);
        CBF = zeros(1,length(Theta));
        for i = 1:length(Theta) 
             weight = exp(-1j*2*pi*dd*(0:kelm-1)'*sind(Theta(i))); 
             CBF(i) = abs(weight'*(X*X')*weight);    
        end
        logP0 = log10(CBF/max(CBF));
        P_CBF = (logP0-min(logP0))/max(logP0-min(logP0)); % 归一化
    end
    