#!/bin/bash
which nvidia-smi >/dev/null 2>&1
if [ $? -eq 0 ] ; then
    nvidia-smi $@
else 
  tryUsrLib=/usr/lib64/nvidia-current/bin/nvidia-smi #PPCLinuxOS
  if [ -f $tryUsrLib ] ; then
     $tryUsrLib $@
  else   
    version=`modinfo nvidia | grep ^version: |grep -o "[0-9]*\.[0-9]*"`
    tryUsrLib=/usr/lib/nvidia-$version/bin/nvidia-smi
    if [ -f $tryUsrLib ] ; then
      $tryUsrLib $@
    else   
      echo "/usr/bin/nvidia-smi not found"
      echo "$tryUsrLib not found"
      echo "Could not find the nvidia-smi utility in your system."
      echo "Do you have the nvidia-bumblebee package installed?"
      echo "If yes, please send the path of your nvidia-smi to csabi@bxabi.com"
      echo "As a workaround you can add it to the PATH"
      echo "or create a symlink to it which is accessible from the PATH"
    fi
  fi
fi
