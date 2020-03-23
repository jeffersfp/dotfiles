# Dotfiles

These are my dotfiles.

In this repo there are configuration files for the following tools:

- Zsh
- Vim
- Visual Studio Code

## Setup

Clone this repo and run the `setup.sh` program.

You if wanna go wild:

```shell
sh -c "$(curl -fsSL https://raw.github.com/jeffersfp/dotfiles/master/setup.sh)" 
```

> Click [here](./setup.sh) to see file content.

## Testing

- Install and setup [Vagrant](https://www.vagrantup.com/).
- Run `vagrant up` in order to start a Ubuntu Bionic VM
- Setup the dotfiles by SSHing into the VM and running the [setup.sh](./setup.sh) file.
