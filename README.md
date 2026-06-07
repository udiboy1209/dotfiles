# Dotfiles repo

Recently started new branch "main". The old dotfiles is in branch "archive".

## Install requirements

### Up-to-date neovim

Version 0.12+ is required for all the plugins to work.
Install from github if package manager is not up-to-date.

```
curl -L https://github.com/neovim/neovim/releases/download/latest/nvim-linux-x86_64.tar.gz | tar -xzv
sudo rm -rf /opt/nvim-linux-x86_64
sudo mv nvim-linux-x86_64 /opt/
```

Make sure the path is added to bashrc (`~/.bashrc.d/nvim`): `export PATH="$PATH:/opt/nvim-linux-x86_64/bin"`

### Tree-sitter for neovim

Manually compile the tree-sitter parsers. Prerequisites are `tree-sitter-cli`, installed via package managers.

```
PARSER_DIR="$HOME/.local/share/tree-sitter"
NVIM_PARSER_DIR="$HOME/.config/nvim/parser"

mkdir -p "$PARSER_DIR" "$NVIM_PARSER_DIR"

# Svelte
git clone --depth=1 https://github.com/tree-sitter-grammars/tree-sitter-svelte "$PARSER_DIR/tree-sitter-svelte"
tree-sitter build "$PARSER_DIR/tree-sitter-svelte" --output "$NVIM_PARSER_DIR/svelte.so"

# JavaScript
git clone --depth=1 https://github.com/tree-sitter/tree-sitter-javascript "$PARSER_DIR/tree-sitter-javascript"
tree-sitter build "$PARSER_DIR/tree-sitter-javascript" --output "$NVIM_PARSER_DIR/javascript.so"

# TypeScript + TSX (both live in the same repo)
git clone --depth=1 https://github.com/tree-sitter/tree-sitter-typescript "$PARSER_DIR/tree-sitter-typescript"
tree-sitter build "$PARSER_DIR/tree-sitter-typescript/typescript" --output "$NVIM_PARSER_DIR/typescript.so"
tree-sitter build "$PARSER_DIR/tree-sitter-typescript/tsx" --output "$NVIM_PARSER_DIR/tsx.so"

# CSS
git clone --depth=1 https://github.com/tree-sitter/tree-sitter-css "$PARSER_DIR/tree-sitter-css"
tree-sitter build "$PARSER_DIR/tree-sitter-css" --output "$NVIM_PARSER_DIR/css.so"

# HTML
git clone --depth=1 https://github.com/tree-sitter/tree-sitter-html "$PARSER_DIR/tree-sitter-html"
tree-sitter build "$PARSER_DIR/tree-sitter-html" --output "$NVIM_PARSER_DIR/html.so"

unset PARSER_DIR NVIM_PARSER_DIR
```


### CLI tools

Tools `fzf`, `uv`, `rg`, `fd`, `starship`

```bash
curl -L https://github.com/junegunn/fzf/releases/download/v0.72.0/fzf-0.72.0-linux_amd64.tar.gz | tar -xzv -C $HOME/.local/bin/
curl -LsSf https://astral.sh/uv/install.sh | sh
curl -L https://github.com/BurntSushi/ripgrep/releases/download/15.1.0/ripgrep-15.1.0-x86_64-unknown-linux-musl.tar.gz | tar -xzv \
    && cp ripgrep-15.1.0-x86_64-unknown-linux-musl/rg $HOME/.local/bin \
    && mkdir -p $HOME/.local/share/bash-completion/completions \
    && cp ripgrep-15.1.0-x86_64-unknown-linux-musl/complete/rg.bash $HOME/.local/share/bash-completion/completions/rg; \
    rm -rf ripgrep-15.1.0-x86_64-unknown-linux-musl # Cleanup regardless
curl -L https://github.com/sharkdp/fd/releases/download/v10.4.2/fd-v10.4.2-x86_64-unknown-linux-musl.tar.gz | tar -xzv \
    && cp fd-v10.4.2-x86_64-unknown-linux-musl/fd $HOME/.local/bin \
    && mkdir -p $HOME/.local/share/bash-completion/completions \
    && cp fd-v10.4.2-x86_64-unknown-linux-musl/autocomplete/fd.bash $HOME/.local/share/bash-completion/completions/fd; \
    rm -rf fd-v10.4.2-x86_64-unknown-linux-musl/ # Cleanup regardless
curl -sS https://starship.rs/install.sh | sh # This will install to root, it is okay
```
- `fd`: ``


### Rust and cargo

Use rustup

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

