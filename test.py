# 批量估计测试集的DOA，并保存至cnn_predict.mat
import keras
import numpy as np
import scipy.io

test_program = scipy.io.loadmat('test_set.mat') #导入测试集
Signal_eta = test_program['Signal_eta'] #31*1000x180，输入空间谱
[nVariable, sample, P] = np.shape(Signal_eta)  # 31*1000x180
est_cnn = np.zeros((nVariable, sample , P)) #DOA空间谱估计结果，31*1000x181
cnn_doa = keras.models.load_model('cnn_doa.h5')
for iVariable in range(nVariable):
    for iSample in range(sample):
        est = cnn_doa.predict(Signal_eta[iVariable, iSample, :].reshape(1,P,1))
        est_cnn[iVariable, iSample, :] = est.reshape(1, 1, P)
scipy.io.savemat('cnn_predict.mat', {'estCNN':est_cnn})
