function P_SBL = sbl_doa(X,numSiganl,dd,Theta)
% P_SBL：SBL-DOA估计的角度
% x:阵列接收信号
% numSignal:信号源数
% dd:阵元间距波长比
% Theta:遍历角度
M1=3;                       
M2=3;
M=M1+M2;                   % Number of element nested array
position=[0:M1 [2:M2]*(M1+1)-1];
etc=M2*(M1);               % Maximum number of active grid points
Snap=size(X,2);
Rx=X*X'/Snap;
Y=Rx(:);
[M2,T]=size(Y);
M=sqrt(M2);
K_hat=length(Theta);
reslu=Theta(2)-Theta(1);
In=eye(M);
In=In(:);
pos_all=round(log(kron(exp(-position),exp(position))));
W=kron(Rx.',Rx)/Snap;
W_sq=sqrtm(inv(W));
Y=W_sq*Y;

%% Initialization
d=0.01;
maxiter=300;
tol=1e-5;
beta0=1;
delta=ones(K_hat+1,1);
a_search=Theta*pi/180;
A=exp(-1i*pi*pos_all'*sin(a_search));
B=-1i*pi*pos_all'*cos(a_search).*A;
A_w=W_sq*A;
B_w=W_sq*B;
I_w= W_sq* In;
Phi=[A_w, I_w];
V_temp=  1/beta0*eye(M2) +  Phi *diag(delta) * Phi';
Sigma = diag(delta) -diag(delta) * Phi' * (V_temp\Phi) *  diag(delta);
mu = beta0*Sigma * Phi' * Y;

converged = false;
iter = 0;
while (~converged) || iter<=100
    
    iter = iter + 1;
    delta_last = delta;
    %% Calculate mu and Sigma
    V_temp=  1/beta0*eye(M2) +  Phi *diag(delta) * Phi';
    Sigma = diag(delta) -diag(delta) * Phi' * (V_temp\Phi) *  diag(delta);
    mu = beta0*(Sigma * (Phi' * Y));
    
    %% Update delta
    temp=sum( mu.*conj(mu), 2) + T*real(diag(Sigma));
    delta= ( -T+ sqrt(  T^2 + 4*d* real(temp) ) ) / (  2*d   );
    
    %% Stopping criteria
    erro=norm(delta - delta_last)/norm(delta_last);
    if erro < tol || iter >= maxiter
        converged = true;
    end
    
    %% Grid refinement
    [~, idx] = sort(delta(1:end-1), 'descend');
    idx = idx(1:etc);
    BHB = B_w' * B_w;
    P = real(conj(BHB(idx,idx)) .* (mu(idx,:) * mu(idx,:)' + Sigma(idx,idx)));
    v =  real(diag(conj(mu(idx))) * B_w(:,idx)' * (Y - A_w * mu(1:end-1)-mu(end)*I_w))...
        -  real(diag(B_w(:,idx)' * A_w * Sigma(1:end-1,idx))  +    diag(Sigma(idx,K_hat+1))*B_w(:,idx).'*conj(I_w));
    eigP=svd(P);
    if eigP(end)/eigP(1)>1e-5
        temp1 =  P \ v;
    else
        temp1=v./diag(P);
    end
    temp2=temp1'*180/pi;
    if iter<100
        ind_small=find(abs(temp2)<reslu/100);
        temp2(ind_small)=sign(temp2(ind_small))*reslu/100;
    end
    ind_large=find(abs(temp2)>reslu);
    temp2(ind_large)=sign(temp2(ind_large))*reslu/100;
    angle_cand=Theta(idx) + temp2;
    Theta(idx)=angle_cand;
%     for iii=1:etc
%         if angle_cand(iii)>= search_mid_left(idx(iii))  && (angle_cand(iii) <= search_mid_right(idx(iii)))
%             search_area(idx(iii))=angle_cand(iii);
%         end
%     end
    A_ect=exp(-1i*pi*pos_all'*sin(Theta(idx)*pi/180));
    B_ect=-1i*pi*pos_all'*cos(Theta(idx)*pi/180).*A_ect;
    A_w(:,idx) =W_sq*A_ect;
    B_w(:,idx) =W_sq*B_ect;
    Phi(:,idx)= A_w(:,idx);
 
end
P_SBL=delta(1:end-1);
end
