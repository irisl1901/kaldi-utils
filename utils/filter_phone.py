
import numpy as np
import os,sys

aalipath = sys.argv[1]
phonepath = sys.argv[2]

phone = []
for root, dirs, files in os.walk(aalipath, topdown=False):
    for name in files:
        alipath = os.path.join(root, name)
        print(alipath)
        ali = open(alipath, 'r')
        for lines in ali.readlines():
            utt = lines.split(' ')[0]
            phone = lines.split(' ')[1:]
            
            if not os.path.exists(phonepath):
               os.makedirs(phonepath)

            if not os.path.isfile(phonepath+'/'+utt+'.phone'):
               op = open(phonepath+'/'+utt+'.phone', 'w')
               for item in phone:
                  if item == '\n':
                     phone.remove(item)
                  # print>>op, item
               arr = np.asarray(phone, dtype=np.int32)
               np.savetxt(op, arr, fmt='%.0f')
               op.close()

