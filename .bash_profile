if [ -r ~/.bashrc ]; then
  source ~/.bashrc
fi

#if [[ "$OSTYPE" == "darwin"* ]]; then
  # needed for brew
  #eval "$(/opt/homebrew/bin/brew shellenv)"
#fi

source ~/.aliases

export XDG_CONFIG_HOME="$HOME"/.config
