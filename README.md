# Introduction

This package provides a `helm` version of [J Vocabulary][dictionary].

[dictionary]: http://www.jsoftware.com/help/dictionary/partsofspeech.htm

The candidates are grouped by parts of speech: `adverbs`, `conjunctions`, `verbs`, and `others`.
They're also arranged into a table with four columns:

1. Word itself.
2. Its monadic name, if applicable.
3. Its dyadic name, if applicable. `"` is used if it's the same as monadic name.
4. Its alternate documentation page name if it has one.

# Usage

First you select a command by either name, e.g. with `+:` or `Double` or `Not Or`.
Next, you can:

1. Stop with `C-g`, since you just wanted to see which name corresponds to what, or
   to see to which part of speech the candidate belongs to.

2. Select one of the 3 actions: "Show 1st doc", "Insert" or "Show 2nd doc".
   The corresponding default helm shortcuts are `RET`, `C-e` and `C-j`.
   Most of the words don't have a 2nd doc (you can see this in the fourth column),
   and 1st doc will be brought up if you press `C-j` and 2nd isn't available.

# Customization
You can customize with `M-x` `customize-group` `RET` `helm-j-cheatsheet` `RET`.
Besides the faces, you can set to `t` the custom `jc-make-insert-primary`, which
results in "Insert" being the first action, instead of "Show 1st doc".
This is more convenient if you want to insert words by English name while coding.
