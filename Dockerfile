FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -S --noconfirm archlinux-keyring

RUN pacman -S --noconfirm base-devel git gdb vim && \
    pacman -S --noconfirm fzf ripgrep zoxide neovim eza starship zsh tmux bat && \
    pacman -S --noconfirm wget curl

RUN --mount=type=cache,sharing=locked,target=/var/cache/pacman \
    pacman -S --noconfirm --needed cuda

RUN pacman -S --noconfirm python-pip nvtop btop htop

# AUR helper
ARG AUR_USER=aur
ARG AUR_HELPER=paru
ADD https://raw.githubusercontent.com/greyltc-org/docker-archlinux-aur/refs/heads/master/add-aur.sh /root/add-aur.sh
RUN bash /root/add-aur.sh "${AUR_USER}" "${AUR_HELPER}" && aur-install mihomo

# zsh configuration
RUN curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

COPY zshrc /root/.zshrc
COPY zimrc /root/.zimrc

RUN zsh -c "ZIM_HOME=/root/.zim source /root/.zim/zimfw.zsh install" && \
    zsh -c "ZIM_HOME=/root/.zim source /root/.zim/zimfw.zsh compile"

# tmux configuration
ADD https://raw.githubusercontent.com/EdenEast/nightfox.nvim/refs/heads/main/extra/nordfox/nordfox.tmux /root/.tmux.conf
RUN echo 'set -g default-terminal "tmux-256color"' >> /root/.tmux.conf && \
      echo 'set -g terminal-overrides "tmux-256color,xterm*:RGB"' >> /root/.tmux.conf && \
      echo 'set -g mouse on' >> /root/.tmux.conf && \
      echo 'set -g allow-passthrough on' >> /root/.tmux.conf && \
      echo 'set -g focus-events on' >> /root/.tmux.conf

# bat configuration
ADD https://raw.githubusercontent.com/EdenEast/nightfox.nvim/refs/heads/main/extra/nordfox/nordfox.tmTheme /root/.config/bat/themes/nordfox.tmTheme
RUN echo "--style=numbers,header" >> /root/.config/bat/config && \
      echo "--theme=nordfox" >> /root/.config/bat/config && \
      bat cache --build

ENV TERM=xterm-256color
ENV COLORTERM=truecolor

ENTRYPOINT ["/usr/bin/zsh"]
