#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

if [ -z "${DOTFILES_FUNCTIONS_LOADED:-}" ]; then
    . ../scripts/functions.sh
fi

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

# Get computer name
computer_name=$(scutil --get ComputerName)

# Build a per-machine ~/.gitconfig.local that reflects THIS user's real
# identity and SSH keys, instead of inheriting the repo author's paths.
# The file is written (not symlinked) because it contains machine-specific
# values that must never be shared between machines.
gitconfig_local="$DESTINATION/.gitconfig.local"
user_name="$(whoami 2>/dev/null || echo "$USER")"
user_email="${USER}@users.noreply.github.com"

# Prefer the user's real signing key if present, else their default ed25519 key.
signing_key=""
for candidate in \
  "$HOME/.ssh/id_signing.pub" \
  "$HOME/.ssh/id_ed25519.pub" \
  "$HOME/.ssh/id_rsa.pub"; do
  if [ -f "$candidate" ]; then
    signing_key="$candidate"
    break
  fi
done

{
  echo "[meta]"
  echo "	isLocalConfig = true"
  echo "[user]"
  echo "	name = $user_name"
  echo "	email = $user_email"
  if [ -n "$signing_key" ]; then
    echo "	signingkey = $signing_key"
  fi
  echo "[gpg \"ssh\"]"
  if [ -f "$HOME/.ssh/allowed_signers" ]; then
    echo "	allowedSignersFile = $HOME/.ssh/allowed_signers"
  fi
} > "$gitconfig_local"

if [ -n "$signing_key" ]; then
  info "Wrote $gitconfig_local (user: $user_name, signing key: $signing_key)"
else
  info "Wrote $gitconfig_local (user: $user_name, no SSH signing key found)"
fi

# Ensure this machine's SSH signing key is registered on GitHub as a signing key.
# Without this, locally-valid signatures show as "Unverified" on GitHub after a key rotation.
register_signing_key() {
  local pubkey keybody
  pubkey="$(git config --get user.signingkey)"

  [ -z "$pubkey" ] && return 0
  case "$pubkey" in *.pub) ;; *) return 0 ;; esac   # SSH signing only, not GPG key ids
  [ -f "$pubkey" ] || { warning "Signing key $pubkey not found; skipping GitHub registration"; return 0; }
  command -v gh >/dev/null 2>&1 || { info "gh not installed; skip GitHub signing-key registration"; return 0; }
  gh auth status >/dev/null 2>&1 || { info "gh not authenticated; skip GitHub signing-key registration"; return 0; }

  keybody="$(awk '{print $1" "$2}' "$pubkey")"
  if gh api /user/ssh_signing_keys --jq '.[].key' 2>/dev/null | grep -qF "$keybody"; then
    info "SSH signing key already registered on GitHub"
  elif gh api -X POST /user/ssh_signing_keys \
        -f "title=$computer_name Signing $(date +%Y-%m)" \
        -f "key=$(cat "$pubkey")" >/dev/null 2>&1; then
    success "Registered SSH signing key on GitHub"
  else
    warning "Failed to register SSH signing key on GitHub (check gh token scope: admin:ssh_signing_key)"
  fi
}

register_signing_key
