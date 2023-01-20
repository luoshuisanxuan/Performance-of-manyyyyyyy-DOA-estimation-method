# 估计单个测试集并画图
import keras
import numpy as np
import scipy.io
import matplotlib.pyplot as plt
import os

test_set = scipy.io.loadmat('OneTestSet.mat') #导入训练数据
theta_test = test_set['thetaOneTest'] # target x 1
Signal_eta = test_set['Signal_eta'] # 1 x 181
Signal_label = test_set['Signal_label'] # 1 x 181
Signal_eta = np.expand_dims(Signal_eta,axis=2) # 1x181x1
Signal_label = np.expand_dims(Signal_label,axis=2) # 1x181x1
[sample, L, dim] = np.shape(Signal_eta) #1个样本，L=180个角度，dim=1
target = np.shape(theta_test) # 目标数
theta = test_set['Phi']
P_MUSIC = test_set['P_MUSIC']
# P_TOEPLITZ = test_set['P_TOEPLITZ']



cnn_doa_last = keras.models.load_model( 'cnn_doa.h5')

DOAs_spectrum = np.zeros((L,sample)) #DOA空间谱估计结果，180x1
#
for i in range(sample):
    DOA_spectrum = cnn_doa_last.predict(Signal_eta)
    DOAs_spectrum[:,i] = DOA_spectrum.reshape(1,L)
    DOAs_spectrum[:,i] = DOAs_spectrum[:,i]/np.max(DOAs_spectrum[:,i])
# for i in range(1):
#     figure, ax = plt.subplots(figsize=[5,4])
#     plt.plot(theta.transpose(),(DOAs_spectrum[:,i]),linewidth=2.0)
#     plt.ylim([-0.1,1.1])
#     plt.xlim([-90,90])
#
#     # plt.plot(theta_test[:,i],np.ones((2,1)),'rD') #target
#     plt.tick_params(labelsize=13)
#     labels = ax.get_xticklabels() + ax.get_yticklabels()
#     [label.set_fontname('Times New Roman') for label in labels]
#     font2 = {'family' : 'Times New Roman','weight' : 'normal','size': 12,}
#     plt.xlabel('CNN-DOA($^o$)',font2)
#     plt.ylabel('DOA Spectrum',font2) #将文件保存至文件中并且画出图
#     #plt.title('DCN')
#     plt.show()
#
# for i in range(1):
#     figure, ax = plt.subplots(figsize=[5,4])
#     plt.plot(theta.transpose(),P_MUSIC.transpose()/np.max(P_MUSIC),linewidth=2.0)
#     plt.ylim([-0.1,1.1])
#     plt.xlim([-90, 90])
#
#     # plt.plot(theta_test[:,i],np.ones((2,1)),'rD') #target
#     plt.tick_params(labelsize=13)
#     labels = ax.get_xticklabels() + ax.get_yticklabels()
#     [label.set_fontname('Times New Roman') for label in labels]
#     font2 = {'family' : 'Times New Roman','weight' : 'normal','size': 12,}
#     plt.xlabel('MUSIC-DOA($^o$)',font2)
#     plt.ylabel('DOA Spectrum',font2) #将文件保存至文件中并且画出图
#     #plt.title('DCN')
#     plt.show()

scipy.io.savemat('cnn_predict_OneTest.mat', {'P_cnn':DOAs_spectrum})

# for i in range(1):
#     figure, ax = plt.subplots(figsize=[5,4])
#     plt.plot(theta.transpose(),P_TOEPLITZ.transpose()/np.max(P_TOEPLITZ),linewidth=2.0)
#     plt.ylim([-0.1,1.1])
#     plt.xlim([-90, 90])
#
#     plt.plot(theta_test[:,i],np.ones((2,1)),'rD') #target
#     plt.tick_params(labelsize=13)
#     labels = ax.get_xticklabels() + ax.get_yticklabels()
#     [label.set_fontname('Times New Roman') for label in labels]
#     font2 = {'family' : 'Times New Roman','weight' : 'normal','size': 12,}
#     plt.xlabel('TOEPLITZ-DOA($^o$)',font2)
#     plt.ylabel('DOA Spectrum',font2) #将文件保存至文件中并且画出图
#     #plt.title('DCN')
#     plt.show()
