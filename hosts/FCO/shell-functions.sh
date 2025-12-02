# convenient shell functions

# quick navigation to git repo root
function cdroot() {
    local root
    root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ $? -eq 0 ]; then
        cd "$root"
    else
        echo "Not in a git repository"
        return 1
    fi
}

# clean Nix store and old generations
function nix-clean() {
    echo "Running Nix garbage collection..."
    if command -v sudo >/dev/null 2>&1; then
        sudo nix-collect-garbage --delete-older-than 7d || true
    else
        nix-collect-garbage --delete-older-than 7d || true
    fi
    echo "Nix GC complete."
}

# update Nix flake inputs and switch
function nix-update() {
    echo "Updating flake inputs and switching..."
    if command -v nix >/dev/null 2>&1; then
        (cd "$HOME/.config/nix" && nix flake update) || {
            echo "nix flake update failed"; return 1;
        }
        sudo darwin-rebuild switch --flake "$HOME/.config/nix#FCO" || {
            echo "darwin-rebuild switch failed"; return 1;
        }
        echo "Nix flake updated and system switched."
    else
        echo "nix command not found"; return 1;
    fi
}

# update Homebrew packages and cleanup
function brew-update() {
    echo "Updating Homebrew packages..."
    if command -v brew >/dev/null 2>&1; then
        brew update && brew upgrade && brew cleanup || {
            echo "Homebrew update/upgrade/cleanup encountered errors"; return 1;
        }
        echo "Homebrew packages updated."
    else
        echo "brew command not found"; return 1;
    fi
}

# run both Nix and Homebrew updates
function update-all() {
    brew-update || return 1
    nix-update || return 1
    echo "All updates completed."
}