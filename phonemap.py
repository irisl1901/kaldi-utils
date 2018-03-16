import numpy as np
import os, sys

(me, phones, path, saveto) = sys.argv

dic = {}
na = []
count = -1
with open(phones, 'r') as f:
   line = f.readlines()
   for l in line:
      p = l.split(' ')[0]
      if '_' in p:
         p = p.split('_')[0]
      if '#' in p:
         continue
      n = l.split(' ')[1].rstrip()
      if p not in na:
         na.append(p)
         count += 1 
      dic[n] = count

#for k, v in sorted(dic.items(), key=lambda (k,v): (v,k)):
#    print(k, v)

#print len(na)
#print na

filelist=os.listdir(path)
filelist.sort()

#if not os.path.exists(saveto):
#   os.makedirs(saveto)

for i in filelist:
   if '.phone' in i:
      with open(path+'/'+i, 'r') as f:
         newp = open(saveto+'/'+i, 'w')
         line = f.readlines()
         for l in line:
            print>>newp, dic[l.rstrip()]
         newp.close() 

