# STOWMAN

```bash
   _==_ _
 _,(",)|_|
  \/. \-|   STOWMAN
__( :  )|_  Manage your dotfiles easily.

```

STOWMAN lets you easily manage your dotfiles using git and GNU stow.

## Usage

### On your current maschine

- Create a GitHub repository.
- Run `stowman.sh init <repo>`
- Add files or folders to stowman using `stowman.sh add <file/folder>`
- Push changes using `stowman.sh push`

### On another maschine

- Run `stowman.sh init<repo>`
- Reload the config by using `stowman.sh reload`

### Syncing changes

- Run `stowman.sh push` to update the repository.
- Run `stowman.sh pull` followed by `stowman.sh reload` to pull and apply the latest changes.
