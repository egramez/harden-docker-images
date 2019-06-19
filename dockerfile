# Dockerfile to build harden Ubuntu container images
# Based on Ubuntu

FROM ubuntu:18.04


RUN dpkg-divert --local --rename --add /sbin/initctl && \
    ln -sf /bin/true /sbin/initctl && \
    apt-get update && \
    apt-get install -y \
    pwgen \
    #harden \
    #harden-nids \
    apt-get upgrade -y && \

# cleanup
    apt-get clean && \

### End installation


# Add appuser

    useradd appuser -m -s /bin/bash && \
    pwgen -N 1 > password.txt && \
    echo "appuser:`cat password.txt`" | chpasswd && \
    usermod -G sudo appuser && \
    mkdir -p /home/appuser/GITHUB && \
    chown appuser:appuser /home/appuser/GITHUB && \

    echo "########################################" && \
    echo " " && \
    echo "PASSWORD For appuser is `cat password.txt`" && \
    echo " " && \
    echo "example to run :- " && \
    echo "docker run --privileged=true -it -d -P --name XXXXXXXX:XXX" && \
    echo " " && \
    echo "########################################" && \

    cd /home/appuser/GITHUB && \
    git clone https://github.com/HarisfazillahJamel/docker-ubuntu-14.04-harden.git && \
    cd && \
    pwd

# Hardening Initialization and Startup Script
ADD hardening.sh /hardening.sh
RUN chmod 755 /hardening.sh

# Set default container command

CMD ["/bin/bash","/hardening.sh"]