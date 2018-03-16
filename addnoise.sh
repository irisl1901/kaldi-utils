#!/bin/bash

corpus=`pwd`/pwavfiles
noisepath=/home/user2/kaldi_ln/noise
dir=`pwd`/nwavfiles-new
#dir=`pwd`

if [ ! -d "$dir" ]; then
  mkdir $dir
fi

choosenoise(){
   random=$(($RANDOM % 9))
   if [ $random -eq '0' ]; then
      noise=$noisepath/DiningHall.wav
   fi
   if [ $random -eq '1' ]; then
      noise=$noisepath/Kindergarden.wav
   fi
   if [ $random -eq '2' ]; then
      noise=$noisepath/Summer.wav
   fi
   if [ $random -eq '3' ]; then
      noise=$noisepath/0.wav
   fi
   if [ $random -eq '4' ]; then
      noise=$noisepath/1.wav
   fi
   if [ $random -eq '5' ]; then
      noise=$noisepath/2.wav
   fi
   if [ $random -eq '6' ]; then
      noise=$noisepath/3.wav
   fi
   if [ $random -eq '7' ]; then
      noise=$noisepath/4.wav
   fi
   if [ $random -eq '8' ]; then
      noise=$noisepath/5.wav
   fi
}

for x in train test; do
   for file in `find -L $corpus/$x -iname '*.wav'` ;do
      uttId=`basename $file`
      dirname=`dirname $file`
      target=$dir/$x/$uttId
      choosenoise
      python3 utils/addnoise.py $file $noise $target   
   done
done
