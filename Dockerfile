FROM jakobwesthoff/ubuntu-environment
MAINTAINER Jakob Westhoff <jakob@westhoffswelt.de>

COPY Library/BASH_PROMPT_NAME /root/.BASH_PROMPT_NAME

RUN apt-get install --yes --no-install-recommends \
    git \
    build-essential \
    openssh-client \
    vim \
    cmake

RUN mkdir "/opt/rpi" && \
    cd "/opt/rpi" && \
    mkdir /root/.ssh/ && \
    ssh-keyscan github.com >>/root/.ssh/known_hosts && \
    git clone git://github.com/raspberrypi/tools.git

#ADD Library/usr-lib-rpi.tar.gz /opt/rpi/
#RUN chown -R root:root /opt/rpi/usr && \
#    chown -R root:root /opt/rpi/lib && \
#    chown -R root:root /opt/rpi/opt

#RUN ln -s /opt/rpi/usr/lib/arm-linux-gnueabihf /usr/lib/arm-linux-gnueabihf && \
#    ln -s /opt/rpi/lib/arm-linux-gnueabihf /lib/arm-linux-gnueabihf && \
#    ln -s /opt/rpi/opt/vc /opt/vc

RUN echo -n 'export PATH="$' >>/root/.bashrc && echo 'PATH:/opt/rpi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin"' >> /root/.bashrc
