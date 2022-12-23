 function P_OMP = omp_doa(X, numSignal, dd, Theta)
    % P_CBF��CBF-DOA������
    % x:���н����ź�
    % numSignal:�ź�Դ��/ϡ���
    % dd:��Ԫ��ನ����
    % Theta:�����Ƕ�
        P_OMP = [];
        Omiga_K = [];
        kelm = size(X,1);
        atom = exp(-1j*2*pi*(0:kelm-1)'*dd*sind(Theta));
        for i = 1:numSignal
            Omiga = [];
            for j = 1:length(Theta)
                Omiga = [Omiga;abs(atom(:,j)'*X)];
            end
            [~,ind] = max(sum(Omiga,2));
            P_OMP(i) = Theta(ind);
            Omiga_K = [Omiga_K,atom(:,ind)];
            X=X-Omiga_K*(Omiga_K'*Omiga_K)^(-1)*Omiga_K'*X;
        end
    end
    