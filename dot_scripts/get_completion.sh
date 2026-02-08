#!/bin/bash

# ----------------------------------------------------------------------------
# 補完ファイルの生成スクリプト
# ~/.zsh/completions に各コマンドの補完定義を出力します
# ----------------------------------------------------------------------------

COMPLETIONS_DIR="$HOME/.zsh/completions"

# ディレクトリがない場合は作成
if [[ ! -d "$COMPLETIONS_DIR" ]]; then
    mkdir -p "$COMPLETIONS_DIR"
    echo "Created directory: $COMPLETIONS_DIR"
fi

echo "Generating completions..."

# --- chezmoi ---
if command -v chezmoi >/dev/null 2>&1; then
    chezmoi completion zsh > "$COMPLETIONS_DIR/_chezmoi"
    echo "Generated: _chezmoi"
else
    echo "Skipped: chezmoi (not found)"
fi

# --- rustup ---
if command -v rustup >/dev/null 2>&1; then
    rustup completions zsh > "$COMPLETIONS_DIR/_rustup"
    echo "Generated: _rustup"
else
    echo "Skipped: rustup (not found)"
fi

# --- cargo ---
if command -v rustup >/dev/null 2>&1; then
    rustup completions zsh cargo > "$COMPLETIONS_DIR/_cargo"
    echo "Generated: _cargo"
else
    echo "Skipped: cargo (rustup not found)"
fi

# --- sheldon ---
if command -v sheldon >/dev/null 2>&1; then
    sheldon completions --shell zsh > "$COMPLETIONS_DIR/_sheldon"
    echo "Generated: _sheldon"
else
    echo "Skipped: sheldon (not found)"
fi

# --- uv ---
if command -v uv >/dev/null 2>&1; then
    uv generate-shell-completion zsh > "$COMPLETIONS_DIR/_uv"
    echo "Generated: _uv"
else
    echo "Skipped: uv (not found)"
fi

# --- proto ---
if command -v proto >/dev/null 2>&1; then
    proto completions --shell zsh > "$COMPLETIONS_DIR/_proto"
    echo "Generated: _proto"
else
    echo "Skipped: proto (not found)"
fi

# --- docker ---
if command -v docker >/dev/null 2>&1; then
    docker completion zsh > "$COMPLETIONS_DIR/_docker"
    echo "Generated: _docker"
else
    echo "Skipped: docker (not found)"
fi

echo "Done! Please restart your shell or run 'compinit' to apply changes."
