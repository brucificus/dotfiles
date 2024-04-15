# About `../rc` Scripts

## 📜 Description

Scripts that are sourced by the shell every time a new shell instance is started.

## 🔙 What has already run?

For login shells, `../rc/*` scripts are always preceded by `../login/*` scripts.

For non-login shells, `../rc/*` scripts do not have antecedents and are the only scripts to run at shell startup.

## ℹ️ Guidelines

Set aliases, functions, shell options, key bindings, etc.

## ⏩ What runs next?

The user arrives at the shell prompt after `../rc/*` scripts are run.
Eventually, the user will exit the shell and `../logout/*` scripts will be run.
