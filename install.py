#!/usr/bin/env python
import os
import os.path
import subprocess


def ensure_symlink(link_path, link_target):
    link_path = os.path.abspath(os.path.expanduser(link_path))
    link_target = os.path.abspath(link_target)
    try:
        os.symlink(link_target, link_path)
        print(f'{link_path} created')
    except FileExistsError:
        link_content = os.readlink(link_path)
        if os.path.join(os.path.dirname(link_path), link_content) == os.path.abspath(link_target):
            print(f'{link_path} is up-to-date')
            return
        raise


def ensure_git_clone(directory, git_url):
    if os.path.exists(os.path.join(directory, '.git')):
        subprocess.check_call(['git', 'pull'], cwd=directory)
    else:
        subprocess.check_call(['git', 'clone', git_url, directory])



ensure_symlink('~/.bashrc', './bashrc')
ensure_symlink('~/.tmux.conf', './tmux.conf')
ensure_symlink('~/.vimrc', './vimrc')
ensure_symlink('~/.gitconfig', './gitconfig')
ensure_symlink('~/.gitignore_global', './gitignore_global')
os.makedirs(os.path.expanduser('~/.vim/pack/minpac/opt'), exist_ok=True)
ensure_git_clone(os.path.expanduser('~/.vim/pack/minpac/opt/minpac'), 'https://github.com/k-takata/minpac.git')
