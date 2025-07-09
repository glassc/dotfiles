FROM node:20
RUN userdel -r node

ARG TZ
ENV TZ="$TZ"

ARG USERNAME="vscode"
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG XDG_CONFIG_HOME=/home/${USERNAME}/.config
ARG XDG_CACHE_HOME=/home/${USERNAME}/.cache
ARG XDG_DATA_HOME=/home/${USERNAME}/.local/share

ENV XDG_CACHE_HOME=${XDG_CACHE_HOME}
ENV XDG_CONFIG_HOME=${XDG_CONFIG_HOME}
ENV XDG_DATA_HOME=${XDG_DATA_HOME}

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    ca-certificates \
    git \
    zsh \
    nano \
    gh \
    wget \
    curl \
    && apt-get clean

RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/zsh -m \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Ensure default node user has access to /usr/local/share
#RUN mkdir -p /usr/local/share/npm-global && \
#  chown -R node:node /usr/local/share


# Persist bash history.
#RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
#  && mkdir /commandhistory \
#  && touch /commandhistory/.bash_history \
#  && chown -R $USERNAME /commandhistory


#RUN ARCH=$(dpkg --print-architecture) && \
#  wget "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_${ARCH}.deb" && \
#  sudo dpkg -i "git-delta_0.18.2_${ARCH}.deb" && \
#  rm "git-delta_0.18.2_${ARCH}.deb"

# Set up non-root user
USER $USERNAME

ENV NPM_CONFIG_CACHE=${XDG_CACHE_HOME}/npm
ENV NPM_CONFIG_PREFIX=${XDG_DATA_HOME}/npm
ENV PATH=$PATH:${XDG_DATA_HOME}/npm/bin

RUN mkdir -p "$XDG_CACHE_HOME" && chmod 700 "$XDG_CACHE_HOME" && chown "$USER:$USER" "$XDG_CACHE_HOME"
RUN mkdir -p "$XDG_CONFIG_HOME" && chmod 700 "$XDG_CONFIG_HOME" && chown "$USER:$USER" "$XDG_CONFIG_HOME"
RUN mkdir -p "$XDG_DATA_HOME" && chmod 755 "$XDG_DATA_HOME" && chown "$USER:$USER" "$XDG_DATA_HOME"


