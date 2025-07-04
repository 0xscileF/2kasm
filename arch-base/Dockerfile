FROM ghcr.io/linuxserver/baseimage-kasmvnc:arch
#IS_REMOTE_WEBTOP FROM lscr.io/linuxserver/webtop:arch-openbox
RUN pacman -Syu --noconfirm && pacman -S --noconfirm base-devel git
RUN mkdir -p /tmp/yay-build
RUN useradd -m -G wheel builder && passwd -d builder
RUN chown -R builder:builder /tmp/yay-build
RUN echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN su - builder -c "git clone https://aur.archlinux.org/yay.git /tmp/yay-build/yay"
RUN su - builder -c "cd /tmp/yay-build/yay && makepkg -si --noconfirm"
RUN rm -rf /tmp/yay-build
RUN pacman -Syu --noconfirm
RUN su - builder -c "yay -S OMNI_PKG --noconfirm"
COPY /root /
RUN chmod -R 777 /defaults/
