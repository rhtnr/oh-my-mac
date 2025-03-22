#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
    echo "Homebrew is not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Check if Zsh is installed
if ! command -v zsh &>/dev/null; then
    echo "Zsh is not installed. Installing..."
    brew install zsh
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# Install Powerlevel10k theme
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
else
    echo "Powerlevel10k is already installed."
fi

# Install required fonts
if ! fc-list | grep -qi "nerd font"; then
    echo "Installing Nerd Fonts..."
    brew tap homebrew/cask-fonts
    brew install --cask font-hack-nerd-font
    brew install --cask font-meslo-lg-nerd-font
    brew install --cask font-fira-code-nerd-font
else
    echo "Required Nerd Fonts are already installed."
fi

# Install plugins
PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"

# zsh-autosuggestions
if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
else
    echo "zsh-autosuggestions is already installed."
fi

# zsh-syntax-highlighting
if [ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting is already installed."
fi

# zsh-fast-syntax-highlighting
if [ ! -d "$HOME/.fast-syntax-highlighting" ]; then
    echo "Installing zsh-fast-syntax-highlighting..."
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting "$HOME/.fast-syntax-highlighting"
    echo "source $HOME/.fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" >> "$HOME/.zshrc"
else
    echo "zsh-fast-syntax-highlighting is already installed."
fi

# zsh-autocomplete
if [ ! -d "$PLUGINS_DIR/zsh-autocomplete" ]; then
    echo "Installing zsh-autocomplete..."
    git clone https://github.com/marlonrichert/zsh-autocomplete.git "$PLUGINS_DIR/zsh-autocomplete"
else
    echo "zsh-autocomplete is already installed."
fi

# Update .zshrc to enable plugins
if ! grep -q "zsh-autosuggestions" "$HOME/.zshrc"; then
    sed -i '' 's/plugins=(/&zsh-autosuggestions /' "$HOME/.zshrc"
fi
if ! grep -q "zsh-syntax-highlighting" "$HOME/.zshrc"; then
    sed -i '' 's/plugins=(/&zsh-syntax-highlighting /' "$HOME/.zshrc"
fi
if ! grep -q "zsh-autocomplete" "$HOME/.zshrc"; then
    sed -i '' 's/plugins=(/&zsh-autocomplete /' "$HOME/.zshrc"
fi
if ! grep -q "dirhistory" "$HOME/.zshrc"; then
    sed -i '' 's/plugins=(/&dirhistory /' "$HOME/.zshrc"
fi

# Install SpaceVim
if [ ! -d "$HOME/.SpaceVim" ]; then
    echo "Installing SpaceVim..."
    curl -sLf https://spacevim.org/install.sh | bash
else
    echo "SpaceVim is already installed."
fi

# Apply changes
source "$HOME/.zshrc"
brew install fzf
brew install --cask font-input
echo "Oh My Zsh setup complete! Restart your terminal or run 'exec zsh' to apply changes."
