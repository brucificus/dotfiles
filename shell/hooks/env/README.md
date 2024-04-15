# About `../env` Scripts

The very first scripts that are sourced by the shell when it starts up.

## 📜 Description

Irrespective of whether the shell is a login shell or not, `../env/*` scripts have *no* guaranteed predecessors.
However, it is *possible* that these same `../env/*` scripts have already been run before, especially in non-login shells.

## ℹ️ Guidelines

Set command search path, other important variables.
No output, no assumption of tty.
The effects should be idempotent, and these should be able to be run multiple times without issue.

## ⏩ What runs next?

In login shells, `../env/*` scripts are followed by `../login/*` scripts.
In non-login shells, `../env/*` scripts are followed by `../rc/*` scripts.
