#!/bin/bash

corpus=./../norm_mfcc
dir=./../../norm_mfcc_noorder

mkdir $dir

for x in train test; do
   mkdir $dir/$x
   for file in `find -L $corpus/$x -iname '*.mfcc'` ;do
      basename=`basename $file`
      echo $basename
      cp $file $dir/$x/$basename
   done
done
