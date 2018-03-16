
from sys import argv
import numpy as np
import os

tmfccdir = argv[1]
mfccdir = argv[2]

data=[]
for root, dirs, files in os.walk(tmfccdir, topdown=False):
    for name in files:
        featspath = os.path.join(root, name)
        print featspath
        with open(featspath,"r") as f:
          line=f.readlines()
          judge=0
          for l in line:
            if '[' in l:
              judge=1
              data.append(l.split(' ')[0]+' start'+'\n')
              continue
            if ']' in l:
              judge=0
              data.append(' '.join(l.split(' ')[2:-1]))
              data.append(' \n'+"done"+'\n')
              continue
            if judge==1:
              data.append(' '.join(l.split(' ')[2:]))
        with open(featspath,"w") as f:
          for i in data:
            f.write(i)
        data=[]

mfcc=[]
for root, dirs, files in os.walk(tmfccdir, topdown=False):
    for name in files:
        featspath = os.path.join(root, name)
        feats = open(featspath, 'r')

        for lines in feats.readlines():
            if 'start' in lines:
                save = root.split('/')[-1]
                utt = lines.split(' ')[0]
                print save,utt

            elif 'done' in lines:
                spkpath = mfccdir+'/'+save
                print spkpath

                if not os.path.exists(spkpath):
                   os.makedirs(spkpath)

                if not os.path.isfile(spkpath+'/'+utt+'.mfcc'):
                   op = open(spkpath+'/'+utt+'.mfcc', 'w')
#                  arr = np.asarray(mfcc)
#                  print arr
#                  np.savetxt(op, arr)
                   for item in mfcc:
                      print>>op, item
                   op.close()
                   mfcc=[]

            else:
                mfcc.append(lines.split(' \n')[0])

