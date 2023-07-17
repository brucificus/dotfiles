
# Interactive login:
#   bash_completion(X) -> bash_profile(env+login) -> bashrc(rc) -> bash_logout(logout)
#   zsh_env(env) -> zprofile(login) -> zshrc(rc) -> zlogin(X) -> zlogout(logout)
#
# Interactive nonlogin:
#   bashrc(rc) ?-> bash_logout(logout)
#   zsh_env(env) -> zshrc(rc) ?-> zlogout(logout)
#
# Script:
#   file://${BASH_ENV}(X) -> bash_logout(logout)
#   zsh_env(?)


- "env": set command search path, other important variables. no output, no assumption of tty. It's effects should be idempotent, and it should be able to be run multiple times without issue.
- "login": set up user's session, e.g. run 'fortune', 'msgs', etc. (?"e.g. start ssh-agent, start tmux, etc.") (no aliases, functions, shell options, key bindings, etc.)
- "rc": set aliases, functions, shell options, key bindings, etc.

For a detailed review of Bash and Zsh startup script ordering, see: https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/

For a note from Zsh on which of their scripts are run in which cases, see: https://zsh.sourceforge.io/Intro/intro_3.html

bash_completion only gets run if bash-completion is installed and enabled.
For more information about how it should be implemented, see: https://serverfault.com/a/831184
