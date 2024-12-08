# STOWMAN

```bash
   _==_ _
 _,(",)|_|
  \/. \-|   stowman.sh
__( :  )|_  Manage your dotfiles easily.

```

stowman.sh lets you easily manage your dotfiles using git and GNU stow.

## Installation

```bash
curl -L https://raw.githubusercontent.com/ad-on-is/stowman/refs/heads/main/stowman.sh > ~/.local/bin/stowman.sh
chmod +x ~/.local/bin/stowman.sh
```

## Usage

### On your current maschine

- Create a GitHub repository.
- Run `stowman.sh init <repo>`
- Add files or folders to stowman using `stowman.sh add <file/folder>`
- Push changes using `stowman.sh push`

### On another maschine

- Run `stowman.sh init <repo>`
- Reload the config by using `stowman.sh reload`

### Syncing changes

- Run `stowman.sh push` to update the repository.
- Run `stowman.sh pull` followed by `stowman.sh reload` to pull and apply the latest changes.
