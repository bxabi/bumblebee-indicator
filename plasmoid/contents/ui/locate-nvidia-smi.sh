#!/bin/bash
which nvidia-smi >/dev/null 2>&1
if [ $? -eq 0 ] ; then
    optirun nvidia-smi $@
else 
   version=`modinfo nvidia | grep ^version: |grep -o "[0-9]*\.[0-9]*"`
   tryUsrLib=/usr/lib/nvidia-$version/bin/nvidia-smi
   if [ -f $tryUsrLib ] ; then
      optirun $tryUsrLib $@
   else   
      echo "/usr/bin/nvidia-smi not found"
      echo "$tryUsrLib not found"
      echo "Could not find the nvidia-smi utility in your system."
      echo "Do you have the nvidia-bumblebee package installed?"
      echo "If yes, please send the path to it to csabi@bxabi.com"
      echo "As a workaround you can add it to the PATH"
      echo "or create a symlink accessible from the PATH"
   fi
fi
