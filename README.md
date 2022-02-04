# vim-lua
```
cd ~

git clone https://github.com/citaty-svyatyh/vim-lua.git

mkdir -p .config

mv vim-lua/ .config/nvim/

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mkdir .local/bin
mv nvim.appimage .local/bin/vim


```

И в файле .bash_profile поменял PATH на локальный в первую очередь.

```
PATH=$HOME/.local/bin:$HOME/bin:$PATH

source  .bash_profile 
```

```

git clone --depth 1 https://github.com/wbthomason/packer.nvim  ~/.local/share/nvim/site/pack/packer/start/packer.nvim

```
