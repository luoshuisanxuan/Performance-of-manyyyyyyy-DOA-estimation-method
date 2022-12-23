    function P_ESPRIT = esprit_doa(X, numSignal, dd, Theta)
    % P_ESPRIT：ESPRIT-DOA估计的两个角度
    % x:阵列接收信号
    % numSignal:信号源数
    % dd:阵元间距波长比
    % Theta:遍历角度
        L = size(X,2);
        kelm = size(X,1)/2;
        R = X*X'/L;
        [Evetor,~] = eig(R);
        Us = Evetor(:,2*kelm-numSignal+1:2*kelm);
        Us1 = Us(1:kelm,:);
        Us2 = Us(kelm+1:2*kelm,:);
        Pusai = pinv(Us1)*Us2;
        Pusai = angle(eig(Pusai))/pi;
        P_ESPRIT = asind(Pusai);
    end
