# 输出训练误差和测试误差曲线
import pickle
import numpy as np
import matplotlib.pyplot as plt

with open('history_cnn_doa','rb') as file_pi:
    history_cnn_doa = pickle.load(file_pi)

figure = plt.subplots(figsize=[8,5])
plt.plot(np.array(history_cnn_doa['loss'])*100,linewidth=3)
#plt.legend(['CNN+doa'])
fontdict = {'family':'Times New Roman','weight':'bold','size': 16}
plt.xlabel('Epoch',fontdict=fontdict)
plt.xlim([-10,200])
plt.ylabel('Train MSE(10$^-$$^2$)',fontdict=fontdict)
plt.ylim([0.0,1.3])
plt.show()
# plt.savefig(fname='fig_training_loss')

figure = plt.subplots(figsize=[8,5])
plt.plot(np.array(history_cnn_doa['val_loss'])*100,linewidth=3)
#plt.legend(['CNN+relu'])
fontdict = {'family':'Times New Roman','weight':'bold','size': 16}
plt.xlabel('Epoch',fontdict=fontdict)
plt.xlim([-10,200])
plt.ylabel('Test MSE(10$^-$$^2$)',fontdict=fontdict)
plt.ylim([0.0,1.3])
plt.show()
# plt.savefig(fname='fig_val_loss')