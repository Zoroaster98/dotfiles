echo "DEBUG: .zshrc is loading..."


nvim() {
  # Set padding to 0 for Neovim
  kitty @ set-font-size 0
  kitty @ set-spacing padding=0
  
  # Launch Neovim
  command nvim "$@"
  
  # Restore original padding (your default is 25)
  kitty @ set-spacing padding=25
  
  # If you need to reset font size too (though this shouldn't be affected)
  kitty @ set-font-size 0  # Reset to default
}

export ELECTRON_OZONE_PLATFORM_HINT=auto
alias neobean='NVIM_APPNAME=linkarzu/dotfiles-latest/neovim/neobean nvim'
export NVIM_APPNAME="neovim"
source ~/.profile

pokemon-colorscripts -r   
