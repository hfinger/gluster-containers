#!/bin/bash

###
# Description: Script to move the glusterfs initial setup to bind mounted directories of Atomic Host.
# Copyright (c) 2016-2017 Red Hat, Inc. <http://www.redhat.com>
#
# This file is part of GlusterFS.
#
# This file is licensed to you under your choice of the GNU Lesser
# General Public License, version 3 or any later version (LGPLv3 or
# later), or the GNU General Public License, version 2 (GPLv2), in all
# cases as published by the Free Software Foundation.
###

main () {
  GLUSTERFS_CONF_DIR="/etc/glusterfs"
  GLUSTERFS_LOG_DIR="/var/log/glusterfs"
  GLUSTERFS_META_DIR="/var/lib/glusterd"
  GLUSTERFS_LOG_CONT_DIR="/var/log/glusterfs/container"

  mkdir $GLUSTERFS_LOG_CONT_DIR
  for i in $GLUSTERFS_CONF_DIR $GLUSTERFS_LOG_DIR $GLUSTERFS_META_DIR
  do
    if test "$(ls $i)"
    then
          echo "$i is not empty"
    else
          bkp=$i"_bkp"
          cp -af $bkp/* $i
          if [ $? -eq 1 ]
          then
                echo "Failed to copy $i"
                exit 1
          fi
          ls -R $i > ${GLUSTERFS_LOG_CONT_DIR}/${i}_ls
    fi
  done

  if test "$(ls $GLUSTERFS_LOG_CONT_DIR)"
  then
        true > $GLUSTERFS_LOG_CONT_DIR/brickattr
        true > $GLUSTERFS_LOG_CONT_DIR/failed_bricks
        true > $GLUSTERFS_LOG_CONT_DIR/lvscan
        true > $GLUSTERFS_LOG_CONT_DIR/mountfstab
  else
        mkdir $GLUSTERFS_LOG_CONT_DIR
        true > $GLUSTERFS_LOG_CONT_DIR/brickattr
        true > $GLUSTERFS_LOG_CONT_DIR/failed_bricks
  fi

  echo "Script Ran Successfully"
  exit 0
}
main
