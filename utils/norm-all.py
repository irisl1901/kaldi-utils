
from sys import argv
import numpy as np
import os

mfccdir = argv[1]
norm_mfccdir = argv[2]

max = 0
min = 0

for root, dirs, files in os.walk(mfccdir, topdown=False):
    for file in files:
        mfccpath = os.path.join(root, file)
        with open(mfccpath, 'r') as f:
            x = np.loadtxt(f)
            x = (x - np.average(x)) / (np.std(x))
            x = x / 7
            if max < np.max(x):
                max = np.max(x)
            if min > np.min(x):
                min = np.min(x)

            print "average:", np.average(x)
            print "std:", np.std(x)
            print "max:", np.max(x)
            print "min:", np.min(x)

        save = root.split('/')[-1]
        normpath = norm_mfccdir+'/'+save
        if not os.path.exists(normpath):
            os.makedirs(normpath)

        with open(normpath+'/'+file, 'w') as output:
            print normpath+'/'+file
            np.savetxt(output, x)

print "total max:", max
print "total min:", min

