# stowman.sh

```bash
   _==_ _
 _,(",)|_|
  \/. \-|   stowman.sh
__( :  )|_  Manage your dotfiles easily.

```

## Installation

```bash
curl -L https://raw.githubusercontent.com/ad-on-is/stowman/refs/heads/main/stowman.sh > ~/.local/bin/stowman.sh
chmod +x ~/.local/bin/stowman.sh
# or clone the repo
git clone https://github.com/ad-on-is/stowman ~/.local/tmp/stowman
chmod +x ~/.local/tmp/stowman/stowman.sh
ln -s ~/.local/tmp/stowman/stowman.sh ~/.local/bin/stowman.sh

```

## Usage

### Environment variables

- `STOWMAN_DOTDIR`: The directory where stowman will store your dotfiles (default: `~/.dotfiles`).
- `STOWMAN_HOMEDIR`: The directory where stowman will stow your dotfiles (default: `~/`).

### On your current machine

- Create a GitHub repository.
- Run `stowman.sh init <repo>`
- Add files or folders to stowman using `stowman.sh add <file/folder> <package>`
- Push changes using `stowman.sh push`

### On another machine

- Run `stowman.sh init <repo>`
- Reload the configuration by using `stowman.sh reload <package|all>`

### Adding files or folders

- Run `stowman.sh add ~/.config/nvim editors` to add `~/.config/nvim` to the `editors` package.
- Run `stowman.sh add . cli` to add the current directory to the `cli` package.

### Syncing changes

- Run `stowman.sh push` to update the repository.
- Run `stowman.sh pull` followed by `stowman.sh reload <package|all>` to pull and apply the latest changes.

### List stowed files and folders

- Run `stowman.sh list` to list all stowed files and folders.
