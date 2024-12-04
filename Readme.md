#### Readme  
##### Usage/Sequence

1、cbf/capon/music/esprit/omp/sbl_doa.m are functions for DOA estimation;

2、train_generate.m is function for generating train_set.mat;  

3、 **TensorFlow** needs to be installed

​	   With the model available in the folder, skip ahead to **step 4**

​	   train.py is function for CNN training;       

​	   figLoss.py plots loss curve

4、Onetest.m generates **one** test sample; 

​	  Onetest.py predicts the result of CNN and feed back cnn_predict_OneTset.mat；

​	  OneTestPerformance shows the performance of cbf/capon/music/esprit/omp/cnn_doa

5、test.m generates samples with the change of variables(SNR/kelm/……)

​	  test.py estimates the DOA with CNN and feed back cnn_predict.mat；

​	  getPeak seeks the DOA of incident signals；

6、AccuracyRMSE.m compares the performance of CNN and classic method；

​	  ShotOrNot.m counts accuracy and RMSE of Estimation;


I would like to express my gratitude to Professor **Duan Keqing**,  **Chen Zhengkun**, **Chen Junzhao**, and **Xu Yiyu** for their guidance.

Our Group WeChat Official Account：

![image-20241204144247757](https://gitee.com/wearlongjohnsevenat30degrees/fortypora/raw/master/img/image-20241204144247757.png)
