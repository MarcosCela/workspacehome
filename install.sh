#!/usr/bin/env sh
echo "This is executed the first time someone logs in the environment"
echo "Install fzf"
sudo apt install fzf


# Installs krew
# https://krew.sigs.k8s.io/docs/user-guide/setup/install/
# This is a plugin manager for kubectl
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
## Once we have krew, install kubectx and kubens as krew plugins
kubectl krew install ctx
kubectl krew install ns

# Remove previous zsh-related files. This is required so that oh-my-zsh installs
# correctly
echo "Removing previous version of dotfiles"
rm -rf ~/.oh-my-zsh
rm ~/.alias ~/.path ~/.zshrc
echo "Installing oh-my-zsh"
# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Create soflinks
ln -s ~/dotfiles/.alias ~/.alias
ln -s ~/dotfiles/.path ~/.path
ln -s ~/dotfiles/.zshrc ~/.zshrc

# Also include the oh-my-zsh folder as a whole
ln -s ~/dotfiles/.oh-my-zsh ~/.oh-my-zsh


echo "It is very much recommended that you restart your shell!"