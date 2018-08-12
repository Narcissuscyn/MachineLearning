import numpy as np
x=np.array([2.5,0.5,2.2,1.9,3.1,2.3,2,1,1.5,1.1])
y=np.array([2.4,0.7,2.9,2.2,3,2.7,1.6,1.1,1.6,0.9])

mean_x=np.mean(x)
mean_y=np.mean(y)
scaled_x=x-mean_x
scaled_y=y-mean_y
data=np.matrix([[scaled_x[i],scaled_y[i]] for i in range(len(scaled_x))])

import matplotlib.pyplot as plt
# plt.plot(x,y,'o')
plt.plot(scaled_x,scaled_y,'o')
plt.show()

cov=np.cov(scaled_x,scaled_y)
eig_val, eig_vec = np.linalg.eig(cov)
eig_pairs = [(np.abs(eig_val[i]), eig_vec[:,i]) for i in range(len(eig_val))]
'''
print:
[(1.2840277121727839, array([-0.6778734 , -0.73517866])),
 (0.049083398938327361, array([-0.73517866,  0.6778734 ]))]
'''
eig_pairs.sort(reverse=True)
feature=eig_pairs[0][1]#get the eigen vector with eigen value and its
'''
print:
array([-0.6778734 , -0.73517866])
'''
new_data_reduced=np.transpose(np.dot(feature,np.transpose(data)))
'''
print:
matrix([[-0.82797019],
        [ 1.77758033],
        [-0.99219749],
        [-0.27421042],
        [-1.67580142],
        [-0.9129491 ],
        [ 0.09910944],
        [ 1.14457216],
        [ 0.43804614],
        [ 1.22382056]])
'''
