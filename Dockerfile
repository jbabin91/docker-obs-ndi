FROM ubuntu:18.04

# Setup environment
ENV HOME=/root \
  DEBIAN_FRONTEND=noninteractive \
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US.UTF-8 \
  LC_ALL=C.UTF-8 \
  DISPLAY=:0.0 \
  DISPLAY_WIDTH=1024 \
  DISPLAY_HEIGHT=768

# Make sure to update the os
RUN apt-get update && apt-get upgrade -y

# Install software-properties-common
RUN apt-get install -y software-properties-common

# Add obs repository
RUN add-apt-repository ppa:obsproject/obs-studio

# Install the dependencies
RUN apt-get install -y \
  bash \
  fluxbox \
  git \
  net-tools \
  obs-studio \
  python \
  python-numpy \
  scrot \
  socat \
  supervisor \
  tigervnc-standalone-server \
  wget \
  x11vnc \
  xterm \
  xvfb

RUN apt-get clean -y

RUN apt-get autoremove -y

RUN rm -rf /var/lib/apt/lists/*

# Install VNC
RUN git clone https://github.com/kanaka/noVNC.git /root/noVNC \
  && git clone https://github.com/kanaka/websockify /root/noVNC/utils/websockify \
  && rm -rf /root/noVNC/.git \
  && rm -rf /root/noVNC/utils/websockify/.git

RUN wget https://github.com/Palakis/obs-ndi/releases/download/4.9.1/libndi4_4.5.1-1_amd64.deb \
  && wget https://github.com/Palakis/obs-ndi/releases/download/4.9.1/obs-ndi_4.9.1-1_amd64.deb \
  && dpkg -i libndi4_4.5.1-1_amd64.deb \
  && dpkg -i obs-ndi_4.9.1-1_amd64.deb

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Modify the launch script 'ps -p'
RUN sed -i -- "s/ps -p/ps -o pid | grep/g" /root/noVNC/utils/launch.sh

# Add menu entries to the container
RUN echo "?package(bash):needs=\"X11\" section=\"DockerCustom\" title=\"Xterm\" command=\"xterm -ls -bg black -fg white\"" >> /usr/share/menu/custom-docker && update-menus
RUN echo "?package(bash):needs=\"X11\" section=\"DockerCustom\" title=\"OBS Screencast\" command=\"obs\"" >> /usr/share/menu/custom-docker && update-menus

# PORT for VNC Client
EXPOSE 5901

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]