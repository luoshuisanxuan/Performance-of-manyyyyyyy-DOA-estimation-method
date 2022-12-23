% funtion for seeking peaks
% input: arr:谱峰搜索的空间谱
%          n:搜索的谱峰个数（信号源）
% output：peakTheta：信号的角度值
function peakTheta = getPeak(arr,n)
    theta = -90:90;
    [peak,peak_index] = findpeaks(arr);
    [~,peak_index_sort] = sort(peak,'descend');
    if length(peak_index_sort)>1
        peakTheta = theta(peak_index(peak_index_sort(1:n)));
    else
        peak_index_sort = ones(1,n)*peak_index_sort;
        peakTheta = theta(peak_index(peak_index_sort(1:n)));
    end 
end