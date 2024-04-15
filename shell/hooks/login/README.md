# About `../login` Scripts

## 📜 Description

Scripts that are sourced by the shell when it starts up, but only for shell logins (i.e. "the first time").

## 🔙 What has already run?

`../login/*` scripts are always preceded by `../env/*` scripts, which are guaranteed to have run at least once before.

## ℹ️ Guidelines

Set up user's session, e.g. run 'fortune', 'msgs', etc. (?"e.g. start ssh-agent, start tmux, etc.").
No aliases, functions, shell options, key bindings, etc.

## ⏩ What runs next?

`../login/*` scripts are always followed by `../rc/*` scripts.
