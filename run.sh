#!/usr/bin/env bash
set -Eeuo pipefail

function update() {

  if ! apt-get -y update; then
    echo "cant update" 1>&2
    return 1
  fi
  return 0
}
function git_maven_terminator_tmux() {

  if ! apt install maven &&
    apt install git &&
    apt install terminator &&
    apt install tmux; then

    return 1
  fi
  return 0
}
function ohmyzsh() {

  if ! apt install zsh; then

    echo "zsh cant install" 1 >&2
    return 1
  fi

  if ! chsh -s "$(command -v zsh)"; then
    echo "zsh cant set default shell" 1 >&2
    return 2
  fi

  if ! sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then

    echo "oh-my-zsh cant install" 1 >&2
    return 3
  fi

  return 0
}

function vim() {

  if ! apt install vim &&
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime &&
    sh ~/.vim_runtime/install_awesome_vimrc.sh; then

    return 1
  fi

  return 0
}

function installjdk() {
  if ! command -v curl; then
    apt install curl
    echo "dont include vim on the machine os cant install jdk " 1>&2
    return 1
  fi
  if ! curl -o jdk11.deb https://d3pxv6yz143wms.cloudfront.net/11.0.5.10.1/java-11-amazon-corretto-jdk_11.0.5.10-1_amd64.deb &&
    apt install jdk11.deb; then
    echo " installation error in jdk" 1>&2
    return 1
  fi

  return 0
}

function spotify_chrome_postman_node_mailspring() {

  if ! command -v snap; then
    apt install snapd
    return 1
  fi
  if
    ! (
      snap install spotify &&
        snap install postman &&
        snap install node --classic
      snap install chromium
      snap install slack --classic
      snap install mailspring
    )
  then
    return 1
  fi

  return 0
}
function docker_dockercompose() {

  if ! snap install docker; then

    "docker installation error" 1 >&2
    return 1
  fi

  if ! curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
    chmod +x /usr/local/bin/docker-compose &&
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose; then

    echo "docker-compose installation error"
    return 2
  fi

  return 0

}

if ! update; then
  echo "cant install anything " 1 >&2
  exit 1
fi

if ! git_maven_terminator_tmux; then
  echo "update is succesfull cant install maven and terminator"
  exit 2
fi

if ! ohmyzsh; then

  exit 3
fi
if ! vim; then

  exit 4
fi
if ! installjdk; then

  exit 5
fi
if ! spotify_chrome_postman_node_mailspring; then

  exit 6
fi
