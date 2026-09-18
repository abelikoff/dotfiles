dotfiles
========

A no-nonsense way to manage my configuration files.

Principles of operation
-----------------------

For every file under `deploy/` directory, the tool will set up a symlink from the directory where it is run, preserving the relative paths. Thus, for example, for file `deploy/.config/wezterm/westerm.lua`, the tool will set up a symlink `<current dir>/.config/wezterm/wezterm.lua` pointing to that file (creating any intermediary directories if needed). This way, one can mix both the configuration files maintained via this system with locally created ones.

When "deploying" each file, the tool will back up any existing files that might
conflict with the ones being deployed.

Installation
------------

Step into a directory where you want to deploy _to_ (most likely `$HOME`) and run:

```
<PATH_TO_DOTFILES>/setup.py
```

By default, the tool will run in "dry run" mode merely proposing the changes to
be made. To actually make the changes, run:

```
<PATH_TO_DOTFILES>/setup.py -f
```

To be asked about each change individually:

```
<PATH_TO_DOTFILES>/setup.py -i
```
