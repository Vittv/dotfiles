# Please read this before proceeding.

Basically, I tried porting the VSCode version of Vague theme, which is made by Viktor Paraj.

I got about 90% of the way done but it seemed to be quite a complex process to mimic exactly how it was there. From what it looks like, due to LSP limitations. I am too new at this to look into this stuff that deeply. I also didn't use any sort of tools to try and make this theme anyway, so this probably could've been easier.

The point is, the theme in its full glory will only work with rainbow-delimeters plugin, which is why I am leaving it inside the same folder. I don't plan to use it any time soon. But, I spent too long tweaking it to just throw it away in the end.
If anyone would like to try the theme out you'll need two things:

- 1. Uncomment the entire vaguevscode/rainbow-delimeters.lua file.
- 2. Write vim.cmd("vaguevscode").colorscheme() at the end of `init.lua`.
