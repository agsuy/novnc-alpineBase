#FROM debian:stretch
FROM alpine:latest

# Add repo
RUN echo "http://dl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Install git, supervisor, VNC, & X11 packages
RUN apk --update --upgrade add --no-cache\
      bash \
      fluxbox \
      git \
      net-tools \
      procps \
      socat \
      sudo \
      supervisor \
      x11vnc \
      xterm \
      xvfb

RUN addgroup -S sudo

RUN adduser --disabled-password --gecos '' novnc

RUN adduser novnc sudo

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /home/novnc/supervisor/logs
RUN mkdir -p /home/novnc/supervisor/pid


RUN git clone https://github.com/kanaka/noVNC.git /home/novnc/repo-noVNC \
	&& git clone https://github.com/kanaka/websockify /home/novnc/repo-noVNC/utils/websockify \
	&& rm -rf /home/novnc/repo-noVNC/.git \
	&& rm -rf /home/novnc/repo-noVNC/utils/websockify/.git

RUN chown -R novnc:novnc /home/


# Setup demo environment variables
ENV HOME=/home/novnc \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    RUN_XTERM=yes \
    RUN_FLUXBOX=yes

COPY . /home/novnc/supervisor/

EXPOSE 8080

USER novnc:novnc

WORKDIR /home/novnc

