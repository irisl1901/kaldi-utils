#!/bin/bash

corpus=`pwd`/nwavfiles
dir=`pwd`/nwsjfeats
deltafeats=`pwd`/ndeltafeats
tempdir=`pwd`/nmfcctemp
mfccdir=`pwd`/nmfcc
normmfccdir=`pwd`/nnormmfcc
testdir=`pwd`/noisetest
traindir=`pwd`/noisetrain

stage=4
. ./utils/cmd.sh
. ./utils/path.sh

for d in $deltafeats $tempdir $mfccdir $normmfccdir; do
   if [ ! -d "$d" ]; then
      mkdir $d
   fi
done

if [ $stage -le 0 ]; then
   if [ -d $dir ]; then
      rm -r $dir
      mkdir $dir
   fi
   echo "Data preparation, files are stored in $dir"
   echo "Preparing unsorted wav.scp and utt2spk"
   for x in train test; do
      for file in `find -L $corpus/$x -iname '*.wav'` ;do
         uttId=`basename $file .wav`
         dirname=`dirname $file`
         spkId=`echo $uttId | head -c 3`
         echo $uttId $file >> $dir/temp_$x'_'wav.scp
         echo $uttId $spkId >> $dir/temp_$x.utt2spk
      done
   done
fi

if [ $stage -le 1 ]; then   
   echo "Sort wav.scp, utt2spk and remove temp files."
   for x in train test; do
     mkdir $dir/$x
     sort -u $dir/temp_$x'_'wav.scp > $dir/$x/wav.scp
     sort -u $dir/temp_$x.utt2spk > $dir/$x/utt2spk
   done
   rm $dir/temp*
fi

if [ $stage -le 2 ]; then   
   echo "Create spk2utt using utt2spk"
   for x in train test; do
     utils/utt2spk_to_spk2utt.pl $dir/$x/utt2spk > $dir/$x/spk2utt
     utils/utt2spk_to_spk2utt.pl $dir/$x/utt2spk > $dir/$x/spk2utt
   done
fi   

if [ $stage -le 3 ]; then
   echo "Make mfcc (13-d)"
   for x in test train; do
       utils/makemfcc.sh --cmd "$train_cmd" --nj 10 $dir/$x || exit 1;
       utils/compute_cmvn_stats.sh $dir/$x || exit 1;
   done
fi

if [ $stage -le 4 ]; then
   echo "Add delta, 13d->39d"
   for x in train test; do
      for d in $tempdir/$x $deltafeats/$x; do
         if [ ! -d "$d" ]; then
            mkdir $d
         fi
      done
      for file in `find -L $dir/$x -iname '*.ark'` ;do
         basename=`basename $file .ark`
         if [ $basename != "cmvn_test" ];then
            if [ "$basename" != "cmvn_train" ];then
               apply-cmvn --utt2spk=ark:$dir/$x/utt2spk scp:$dir/$x/cmvn.scp ark:$file ark:- | \
               add-deltas --delta-window=3 --delta-order=2 ark:- ark:$deltafeats/$x/$basename.ark
               copy-feats ark:$deltafeats/$x/$basename.ark ark,t:$tempdir/$x/$basename.ark
            fi
         fi
      done
   done
fi

if [ $stage -le 5 ]; then
   python2 utils/filter_mfcc.py $tempdir $mfccdir
fi

if [ $stage -le 6 ]; then
   python2 utils/norm-all.py $mfccdir $normmfccdir
fi

if [ $stage -le 7 ]; then
   cp -r $normmfccdir/train $traindir
   cp -r $normmfccdir/test $testdir 
   #rm -r $tempdir
fi
