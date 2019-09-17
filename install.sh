#!/bin/bash
vim_implementation=""

if hash nvim 2> /dev/null; then
    echo "NeoVim detected!"
    vim_implementation=nvim
    if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
	echo "Installing Plug-Vim for Neovim"
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi 
else if hash vim 2> /dev/null; then
	echo "Vim detected"	
	vim_implementation=vim
	if [ ! -f ~/.vim/autoload/plug.vim ]; then
	    echo "Installing Plug-Vim for Vim"
	    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	fi
    else	
	echo "ERROR: Install Vim or Neovim"
	exit 1
    fi
fi

echo "Copying settings"

if [ $vim_implementation == "nvim" ]; then
    if [ ! -d ~/.config/nvim/ ]; then
	mkdir ~/.config/nvim
    fi
    cp coc-settings.json init.vim ~/.config/nvim
else
    cp init.vim ~/.vimrc
    cp coc-settings.json ~/.vim/
fi  

PlugInstall_command="-c 'exe \"silent! PlugInstall\" | exe \"q!\" | exe \"q!\"'"

eval $vim_implementation $PlugInstall_command  
echo "Extensions installed"

if ! hash ccls 2> /dev/null; then
    echo "WARNING: Missing dependency ccls"
fi

if ! hash node 2> /dev/null; then
    echo "WARNING: Missing dependency node"
fi

if ! hash npm 2> /dev/null; then
    echo "WARNING: Missing dependency npm"
fi

exit 0
