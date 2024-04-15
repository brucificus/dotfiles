# About `../logout` Scripts

## 📜 Description

Scripts that are sourced by the shell when it exits.

## 🔙 What has already run?

The entirety of the shell session has already run, including `../rc/*` scripts and their antecedents.

## ℹ️ Guidelines

Explicitly clean up temporary files, clear the screen, etc.

## ⏩ What runs next?

Nothing. The shell terminates after `../logout/*` scripts are run.
