---
layout: compsci-note
title: Git Notes
categories: [tools]
description: Some notes on git
order: 20
sitemap: false
---

## Contents

* [Line endings](#annoying-line-ending-differences)
* [Grep](#grep)
* [Your own gitignore](#your-own-gitignore)
* [Using Head^ and HEAD~](#using-head-and-head)
* [Using multiple SSH keys](#using-multiple-ssh-keys)
* [Submodules](#submodules)

## Generating SSH keys (copy paste from Github)

```bash
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
$ eval $(ssh-agent -s)
$ ssh-add ~/.ssh/id_rsa
$ cat ~/.ssh/id_rsa.pub
```

## Commands easy to forget

```bash
$ git remote -v
$ git rebase -i branchname or commit hash
$ git log --stat
$ git log --graph
$ git checkout other-branch the/path/to/yourfile
$ git diff yourbranch otherbranch -- file
$ git merge --reset

```

## Tags

Annotated (with message) and light-weight (no message).

```bash
$ git tag
$ git push origin tag_name
$ git show tag_name
$ git log -1 tag_name
```

## Annoying line-ending differences

### Checkout Windows-style, commit Unix-style

`git config core.autocrlf true`

Git will convert LF to CRLF when checking out text files. When committing text files, CRLF will be converted to LF. For cross-platform projects, this is the recommended setting on **Windows**.

### Checkout as-is, commit Unix-style

`git config core.autocrlf input`

Git will **not** perform any conversion when checking out text files. When committing text files, `CRLF` will be converted to `LF`. For cross-platform projects this is the recommended setting on **Unix**.

### Checkout as-is, commit as-is

`git config core.autocrlf false`

Git will **not** perform any conversions when checking out or committing text files. Choosing this option is **not** recommended for cross-platform projects.

## Gitignore

To create a user `.gitignore` and **not** global, do:

```bash
# go to your repo .git folder
$ cd <your-repo>/.git

# populate with your files/folders
$ nano .user_gitignore

# add it to your config
$ git config core.excludesfile .git/.user_gitignore

# you can see it is added
$ git config -l
```

To create a **global** `.gitignore`, do:

```bash
# or where desired
$ git config --global core.excludesfile ~/.global_gitignore
```

## Using HEAD^ and HEAD~

Basically `HEAD^` is doing a BFS traversal while `HEAD~` only recognizes the first parent but can select the leaves using the caret e.g. `H = A^^^2 = A~2^2`

```text
G   H   I   J
 \ /     \ /
  D   E   F
   \  |  / \
    \ | /   |
     \|/    |
      B     C
       \   /
        \ /
         A

A =      = A^0
B = A^   = A^1     = A~1
C = A^2  = A^2
D = A^^  = A^1^1   = A~2
E = B^2  = A^^2
F = B^3  = A^^3
G = A^^^ = A^1^1^1 = A~3
H = D^2  = B^^2    = A^^^2  = A~2^2
I = F^   = B^3^    = A^^3^
J = F^2  = B^3^2   = A^^3^2
```

## Using multiple SSH keys

Useful if you have bitbucket, github etc. and want to use different ssh keys instead of sharing them - for ~~security~~
 inconvenience reasons

1. Generate a ssh key and add it to your account e.g. bitbucket_rsa
2. Edit your `~/.ssh/config`:

    ```conf
    # ~/.ssh/config

    # Github
    Host github-foobar
            HostName github.com
            User git
            IdentityFile ~/.ssh/id_rsa

    # Bitbucket
    Host bitbucket-deadbeef
            HostName bitbucket.com
            User git
            IdentityFile ~/.ssh/bitbucket_rsa
    ```

3. Now you can add a new `remote` that uses your new ssh key

    ```bash
    # git remote add <remote_name> git@<new_host>:<username>/<repo>.git
    $ git remote add bitbucket git@bitbucket-deadbeef:deadbeef/some-repo.git
    ```

4. Now we can push to our new remote with our new ssh key!

    ```bash
    $ git fetch bitbucket master
    $ git push bitbucket master
    ```

## Submodules

### Adding changes in the submodule

From [StackOverflow](https://stackoverflow.com/questions/5542910/how-do-i-commit-changes-in-a-git-submodule):

A submodule is its own repo/work-area, with its own `.git` directory. When cloning, use the `--recurse-submodules`.

So, first commit/push your submodule's changes:

```bash
$ cd path/to/submodule
$ git add <stuff>
$ git commit -m "submodule changes"
$ git push
```

Then, update your main project to track the updated version of the submodule:

```bash
$ cd /main/project
$ git add path/to/submodule
$ git commit -m "updated my submodule"
$ git push
```

### Updating all submodules

If you want to update all your submodules to the latest commit available from their remotes:

```bash
$ git submodule foreach git pull origin master
```
