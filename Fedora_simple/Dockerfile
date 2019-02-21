FROM registry.fedoraproject.org/fedora:latest

ENV NAME="gluster-fedora" \
    DESC="GlusterFS on Fedora" \
    VERSION=0 \
    RELEASE=1 \
    ARCH=x86_64 \
    REPO="$FGC" \
    container=docker

COPY gluster-setup.sh /

RUN dnf -y update && \
    sed -i "s/LANG/\#LANG/g" /etc/locale.conf && \
    dnf -y install glusterfs-server attr iputils iproute glusterfs-geo-replication openssh-server openssh-clients cronie tar rsync sos sudo xfsprogs && \
    dnf clean all;

# ssh server and client are needed for geo-replication
RUN sed -i '/Port 22/c\Port 2228' /etc/ssh/sshd_config

# Back up the default/base configuration. The target directories get
# overwritten with the directories from the host which are initially
# empty. gluster-setup.sh will then restore the configurations into the mounted host volumes.
RUN mkdir -p /etc/glusterfs_bkp /var/lib/glusterd_bkp /var/log/glusterfs_bkp && \
    cp -r /etc/glusterfs/* /etc/glusterfs_bkp && \
    cp -r /var/lib/glusterd/* /var/lib/glusterd_bkp && \
    cp -r /var/log/glusterfs/* /var/log/glusterfs_bkp && \
    chmod +x /gluster-setup.sh && \
    mkdir -p /var/log/core;

# Expose ports:
# port 2228 sshd (geo replication)
# port 24007 glusterd (management)
# ports 49152-49251 gluster (data path)
EXPOSE 2228 24007 49152 49153 49154 49155 49156 49157 49158 49159 49160 49161 49162

CMD ["sh","-c","/gluster-setup.sh && glusterd --no-daemon"]

