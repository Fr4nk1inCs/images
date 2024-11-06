FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -S --noconfirm archlinux-keyring

RUN pacman -S --noconfirm base-devel git gdb vim && \
    pacman -S --noconfirm fzf ripgrep zoxide neovim eza starship zsh tmux && \
    pacman -S --noconfirm wget curl

RUN curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

COPY zshrc /root/.zshrc
COPY zimrc /root/.zimrc

RUN zsh -c "ZIM_HOME=/root/.zim source /root/.zim/zimfw.zsh install" && \
    zsh -c "ZIM_HOME=/root/.zim source /root/.zim/zimfw.zsh compile"
