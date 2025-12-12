# My scripts directory

## Location
If you wish to use these scripts yourself, I recommend having them all under `~/.local/bin`.

That seems to be the best practice location for personal scripts, and that way we can keep things organized. Also, have in mind that some of my configs like for example my `.bashrc`, rely on having the scripts in such location.

## Making it executable
You can use `chmod +x ~/.local/bin/scriptname` to make them executable from anywhere in the terminal! That way you can easily run a script by calling their file name alone, e.g. `mudfish.sh`. If everything is correct, you will also know it is right because you'll be able to autocomplete the name of the script.

## Setting environment variables
If you have a brand new `.bashrc`, you might have to set the environment variable so your system can find the script on the `$PATH`. For `cutefetch` for example you will need `export PATH="$HOME/.local/bin:$PATH"` written somewhere in your .bashrc or .zshrc, whatever you use.

## Sourcing it
Make sure to `source ~/.bashrc` to apply the changes made on your shell.

Happy hacking!
