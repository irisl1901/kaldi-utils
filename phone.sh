#!/bin/bash

stage=3
srcdir=`pwd`/tri3b
alidir=`pwd`/ali
phonedir=`pwd`/phone
featdir=`pwd`/pwsjfeats
langdir=`pwd`/lang_nosp_bd
cmd=utils/run.pl

#. utils/parse_options.sh
. ./utils/path.sh

if [ $stage -le 1 ]; then
   echo "$stage: aligning data in $featdir using model from $srcdir, putting alignments in $alidir"
   #for x in train test; do
   for x in train; do
      align_si.sh $featdir/$x $langdir $srcdir $alidir 
   done
    
fi

if [ $stage -le 2 ]; then
   echo "$stage: converting ali to phone, putting phone in $phonedir"
   #for x in train test; do
   for x in train; do
      mkdir $alidir/tali
      for file in `find -L $alidir/$x -iname 'ali.*.gz'` ;do
         basename=`basename $file .gz`
         gunzip -c $file > $alidir/temp
         ali-to-phones --per-frame $alidir/final.mdl ark:$alidir/temp ark,t:$alidir/tali/$basename
         rm $alidir/temp
      done
   done
fi  

if [ $stage -le 3 ]; then
   echo "$stage: filter"
   python2 utils/filter_phone.py $alidir/tali $phonedir
fi 
