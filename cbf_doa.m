    function P_CBF = cbf_doa(X, numSignal, dd, Theta)
    % P_CBF��CBF-DOA������
    % x:���н����ź�
    % numSignal:�ź�Դ��(��������ò��ϣ�����һ����)
    % dd:��Ԫ��ನ����
    % Theta:�����Ƕ�
        kelm = size(X,1);
        CBF = zeros(1,length(Theta));
        for i = 1:length(Theta) 
             weight = exp(-1j*2*pi*dd*(0:kelm-1)'*sind(Theta(i))); 
             CBF(i) = abs(weight'*(X*X')*weight);    
        end
        logP0 = log10(CBF/max(CBF));
        P_CBF = (logP0-min(logP0))/max(logP0-min(logP0)); % ��һ��
    end
    