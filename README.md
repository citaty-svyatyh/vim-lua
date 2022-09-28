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

## Cannot access member "objects" for Mongoengine models
> This is the top result when searching this particular issue but I initially missed the resolution. If you are using a Python virtual environment, the following commands should be run using your project's virtual environment.
> 
> 1. Install `mypy` if you do not already have it installed; this will add the `stubgen` command:
> 
> ```
> pip install mypy
> ```
> 
> 2. In the root directory of your project run the following command:
> 
> ```
> stubgen -o typings -p mongoengine
> ```
> 
> 3. Navigate to `typings/mongoengine/document.pyi` and locate the `Document` class definition.
> 4. Add the following function definition to the `Document` class definition:
> 
> ```
> @staticmethod
> def objects(**kwargs): ...
> ```



