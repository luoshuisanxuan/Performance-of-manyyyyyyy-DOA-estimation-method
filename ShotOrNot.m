% ����׼ȷ������������ʹ��
% estMeasure����ӦDOA���Ƶ�����Ǽ���
% ThetaTest����ʼ�趨������Ƕ�
% threshold���ж���ȷ������
% AccuracyEst������׼ȷ��
% RmseEst�����Ƶľ��������
function [AccuracyEst,RmseEst] = ShotOrNot(estMeasure,ThetaTest,threshold)
    nLevel = size(estMeasure,1);
    nSignal = 2;
    nsample = size(estMeasure,3);
    AccuracyEst = zeros(1,nLevel);
    RmseEst = zeros(1,nLevel);
    error = zeros(1,nLevel);
    for iLevel = 1:nLevel
        shot = zeros(nsample,1);
        ests = reshape(estMeasure(iLevel,:,:),nSignal,nsample);
        for isample = 1:nsample
            est = sort(ests(:,isample));
            label = sort(ThetaTest(:,isample));
            if abs(est(1)-label(1))==0 && abs(est(2)-label(2))==0
                shot(isample) = 1;
            elseif abs(est(1)-label(1))<=threshold && abs(est(2)-label(2))<=threshold
                shot(isample) = 1;
            end
            error(iLevel) = error(iLevel)+sum((est-label).^2);
        end        
        AccuracyEst(iLevel) = sum(shot)/nsample;
        RmseEst(iLevel) = sqrt(error(iLevel)/(nSignal*nsample));
    end
end