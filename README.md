# E.Dots

macOS 上的个人 dotfiles 配置，基于 [Fish shell](https://fishshell.com/) + [GNU Stow](https://www.gnu.org/software/stow/) 管理，包含一套新机器初始化脚本。

> [!WARNING]
> 这是个人配置，会频繁变动。不要盲目 fork 后直接运行 `install.sh`，请先阅读脚本内容。脚本支持子命令，参见 `./install.sh help`。

| 截图 | 截图 |
| --- | --- |
| ![aerospace+sketchbar](./local/.local/__repoImages/2026/1-aerospace+sketchbar.png) | ![bat](./local/.local/__repoImages/2026/2-bat.png) |
| ![btop](./local/.local/__repoImages/2026/3-btop.png) | ![fastfetch-fish](./local/.local/__repoImages/2026/4-fastfetch-fish.png) |
| ![lazygit](./local/.local/__repoImages/2026/5-lazygit.png) | ![nvim-picker](./local/.local/__repoImages/2026/6-nvim-neoed-picker.jpeg) |
| ![nvim-dash](./local/.local/__repoImages/2026/7-nvim-neoed-dash.png) | ![theme-switcher](./local/.local/__repoImages/2026/8-theme-switcher.png) |
| ![vscode](./local/.local/__repoImages/2026/9-vscode.png) | ![yazi](./local/.local/__repoImages/2026/10-yazi.png) |

## 目录

- [安装前提](#安装前提)
- [安装步骤](#安装步骤)
- [justfile 命令](#justfile-命令)
- [Stow 包](#stow-包)
- [脚本](#脚本)
- [疑难排查](#疑难排查)

## 安装前提

新机器初始化步骤：

1. 安装 Xcode 命令行工具：`sudo softwareupdate -i -a && xcode-select --install`（会附带安装 `git` 和 `make`）
2. 生成 SSH 密钥并添加到 GitHub：
   - `ssh-keygen -t ed25519 -C "you@host" -f ~/.ssh/id_ed25519` — 认证密钥
   - `ssh-keygen -t ed25519 -N "" -C "git signing" -f ~/.ssh/id_signing` — 签名密钥（无密码短语）
   - 将 `id_ed25519.pub` 添加为 GitHub 的 **Authentication** 密钥，`id_signing.pub` 添加为 **Signing** 密钥
   - `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`
3. 克隆仓库：
   ```shell
   git clone https://github.com/GUARDIANANGLE/dotfiles.git ~/.dotfiles
   ```
4. 用 `justfile` 完成后续配置（见下）
5. 配置完成后，运行 `upp`（即 `topgrade --yes`）更新所有软件包
6. 可选：
   - 安装应用时关闭 Gatekeeper：`sudo spctl --master-disable`
   - Node 版本按需切换，首次调用 `node`/`npm` 时自动初始化 `fnm`

## 安装步骤

### 一键安装

克隆仓库到 `~/.dotfiles` 后引导机器（未经全新安装测试，运行前请先阅读 `install.sh` 和 `justfile`）：

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/GUARDIANANGLE/dotfiles/master/install.sh)" -- bootstrap
```

或先克隆再本地运行：

```shell
git clone https://github.com/GUARDIANANGLE/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./install.sh bootstrap
```

### 引导（bootstrap）

`./install.sh bootstrap` 会安装：Xcode CLT、Homebrew + Brewfile、语言包管理器（FNM、rbenv、rustup、Bun）、Stow、duti、macOS 偏好设置、git 配置、Empryo，以及可选的 fish 作为默认 shell。

`bootstrap` 支持的 flag：

- `-y` / `--yes` — 跳过所有提示
- `--no-packages` — 跳过 Homebrew bundle 和语言包管理器
- `--no-macos` — 跳过系统偏好设置

完整用法见 `./install.sh help`。

### 仅链接（link）

`./install.sh link` 只创建 dotfiles 符号链接（幂等），适用于机器已经配置好的情况。

## justfile 命令

在 `~/.dotfiles` 根目录下运行，`just --list` 是权威来源：

```shell
default       显示可用命令
install       引导新机器（完整配置）[别名: bootstrap]
link          用 Stow 链接所有 dotfiles（幂等）[别名: run]
list          列出可用的 stow 包
stow          添加单个包（如 just stow fish）[别名: add]
unstow        移除单个包（如 just unstow fish）[别名: remove]
update        重新链接所有包 [别名: up]
delete        删除所有 dotfile 符号链接
hooks         安装 .githooks 到 .git/hooks
capture-empryo  将 ~/.empryo/config.json 复制回仓库
```

### Stow 管理

两种方式管理包：

1. 直接用 Stow：`stow fish`、`stow --restow fish`、`stow -D fish`（取消链接）
2. 用 justfile：`just stow fish` 或 `just unstow fish`

`just update` 会重新链接所有包，并先清理陈旧的 `brew.fish`/`fish-ssh-agent.fish` 链接和 zsh 补全缓存。

### Git hooks

`just hooks` 会在 `.git/hooks` 安装包装脚本，调用 `.githooks/commit-msg`（Conventional Commits）。已无 pre-commit hook：可直接从 git、LazyGit 或 grit 提交到 `master`。

## Stow 包

包列表在 `justfile` 的 `stow_packages` 中：`dots git fish zsh config neovim local readinglist`。

- **dots**（`dots/`）— 直接放在 `$HOME` 下的杂项 dotfiles：`.npmrc`、`.tmux.conf`、`.profile` 等，以及共享的 `.stow-global-ignore`。`.empryo/` 存放全局 Empryo 配置（`config.json` 是复制而非链接，`just capture-empryo` 可把实时文件复制回仓库）。

- **git**（`git/`）— `.gitconfig`（别名、delta pager、SSH 签名）、`.gitignore_global`，以及 `git.sh`（按机器名链接 `~/.gitconfig.local` 并在 GitHub 注册签名密钥）。用 `git config --get-regexp '^alias\.'` 列出别名。

- **fish**（`fish/`）— 主 shell，XDG 兼容。
  - **提示符**：`config.fish` 里的 `FISH_PROMPT` 选择提示引擎，默认 Starship（配置在 `config/.config/starship.toml`）。
  - **密钥**：API key 放在 `conf.d/secrets.fish`（gitignored），从 `conf.d/secrets.fish.example` 复制创建。
  - **懒加载**：重工具首次使用时才初始化。`config.fish` 为 `node`/`npm`/`npx`（FNM）和 `ruby`/`gem`/`bundle` 等（rbenv）定义了包装函数，首次调用时初始化后自销毁并转交。`npx` 转交 `bunx`。
  - **缩写而非别名**：`conf.d/abbr.fish`，运行 `abbr` 查看。多步命令放在 `functions/`。
  - **插件**：由 [Fisher](https://github.com/jorgebucaran/fisher) 管理，列在 `fish_plugins`。
  - **SSH agent**：`conf.d/fish-ssh-agent.fish` 让所有 shell 共享同一个 agent（见疑难排查）。

- **zsh**（`zsh/`）— 与 Fish 几乎一致的镜像配置，用于 Zsh 兼容（`ZDOTDIR=~/.config/zsh`）。
  - **插件管理**：[Antidote](https://getantidote.github.io/)，插件在 `.zsh_plugins.txt`。
  - **模块化**：`.zshrc.d/` 下编号文件按序加载，对应 Fish 的 `conf.d/`。
  - **懒加载**：FNM、rbenv、zoxide 首次使用时加载。
  - **密钥**：`secrets.zsh`（gitignored），从 `secrets.zsh.example` 复制。

- **config**（`config/`）— 20+ 应用的 `~/.config`：bat、btop、fastfetch、gh、ghostty、herdr、karabiner、kitty、lazygit、raycast、starship、superfile、topgrade、wezterm、yazi、zed 等。
  - **终端**：WezTerm（主，模块化 Lua）、Kitty、Ghostty。
  - **主题切换**：运行 `theme` 打开 fzf 选择器，`theme <name>` 直接切换，`theme --list` / `--current` 查看。13 套主题应用到终端、Neovim、bat、lazygit 等多个应用。
  - **键盘**：`leaderkey`（当前）和 `karabiner`（遗留 TypeScript 配置）。
  - **编辑器**：`zed`（Vim 模式）。

- **neovim**（`neovim/`）— 基于 LazyVim 的配置，主编辑器。Stow 把 `~/.config/nvim` 链接到 `neovim/.config/nvim/`。含 Vite+ 格式化/lint、AI 集成、多语言支持。详见 `neovim/.config/nvim/README.md`。

- **local**（`local/`）— `~/.local`：`bin/` 脚本、cspell 词典、键盘/鼠标布局备份、GitHub CLI 扩展。仓库截图在 `__repoImages/`，不参与 stow。

- **readinglist**（`readinglist/`）— 把 Safari 阅读列表新条目保存为 FieldNotes Obsidian 笔记。Stow `~/.local/bin/rl2notes`；`just readinglist` 生成并加载 LaunchAgent。

## 脚本

这些脚本由 `install.sh bootstrap` 运行，也可单独运行（需从各自目录执行，因为它们按相对路径 source `../scripts/functions.sh`）。

- **macOS**（`macos/`）— `macos.sh` 依次运行 `01-preferences.sh`、`02-apps.sh`、`03-security.sh`。**不要盲目运行**，它是 WIP，每次 macOS 更新都可能有变化。

- **packages**（`packages/`）— `packages.sh` 安装（和卸载）Brewfile 及各包管理器的清单。
  - 用法：`./packages.sh [action] [target]`，action 为 `install`（默认）/`uninstall`，target 为 `brew`、`node`、`bun`、`pnpm`、`ruby`、`rust`、`all`。
  - 清单：`Brewfile`、`node_packages.txt`、`bun_packages.txt`、`ruby_packages.txt`、`rust_packages.txt`。Bun 管理全局 JavaScript CLI；目前没有 `pnpm_packages.txt`，跳过 `pnpm` target。

  ```fish
  ./packages.sh                  # 安装全部（默认）
  ./packages.sh bun              # 只装 Bun 全局包
  ./packages.sh uninstall bun    # 移除 bun_packages.txt 里的所有包
  ./packages.sh uninstall all    # 移除全部（逆序，brew 最后）
  ./packages.sh --help           # 完整参考
  ```

- **duti**（`duti/`）— `duti.sh` 为各文件类型设置默认应用（每个应用 bundle id 一个文件）。

- **git**（`git/`）— `git.sh` 链接按机器的 `~/.gitconfig.local`，并在 GitHub 注册 SSH 签名密钥。

- **scripts**（`scripts/`）— `functions.sh` 提供共享的 `info`/`success`/`warning`/`error` 帮助函数。`nvim.sh` 是遗留的 LazyVim 启动辅助脚本，`install.sh` 已不再调用。

- **private**（`private/`）— 空占位；`private/ssh/` 已 gitignore。

## 疑难排查

<details>
  <summary>Fish：Fisher 插件管理器</summary>

如果 Fisher 出现异常或引入破坏性变更，重装即可：

```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

</details>

<details>
  <summary>Node 开发：FNM</summary>

Node 版本切换用 [fnm](https://github.com/Schniz/fnm)，同时支持 `.nvmrc` 和 `.node-version`。

未安装时：`brew install fnm`

FNM 懒加载：首次 `node`/`npm`/`npx` 调用时才初始化。补全缺失时 `fnm completions --shell fish`。改完 fish 配置后执行 `just update` 和 `reload`。

全局 Node 包在 `packages/node_packages.txt`；JavaScript CLI 放 `packages/bun_packages.txt`（Bun 负责全局包）。

</details>

<details>
  <summary>Git：提交和标签签名</summary>

使用 SSH 签名而非 GPG。`.gitconfig` 最后 include `~/.gitconfig.local`，让机器级配置生效：

```ini
[meta]
  isLocalConfig = true
[user]
  signingkey = PATH_TO_YOUR_KEY
[gpg "ssh"]
  allowedSignersFile = PATH_TO_YOUR_ALLOWED_SIGNERS_FILE
```

`git/git.sh` 按 `ComputerName` 链接对应的 `git/gitconfig-<machine>.local`，并在缺失时把公钥注册到 GitHub。

> [!IMPORTANT]
> `signingkey` 应指向**专用的、无密码短语的密钥**（如 `~/.ssh/id_signing.pub`），而不是认证密钥。`ssh-keygen -Y sign` 直接读私钥，没有 macOS 钥匙串挂钩，带密码短语的签名密钥会导致每次提交都要输入。认证用带密码短语的 `id_ed25519`，签名单独生成 `id_signing`，两者分别添加到 GitHub 对应槽位。

</details>

<details>
  <summary>Rust 和 Cargo</summary>

偶尔 `cargo` 通过 `topgrade` 更新失败，通常是 Rust 工具链变动导致 `cargo install cargo-update` 出错。

**修复**：用 brew 卸载重装 `rust` 和 `rustup-init`，再重装 `cargo-update`：

```shell
brew uninstall rustup-init;
and brew reinstall rust;
and cargo install cargo-update --force;
and topgrade --only cargo
```

</details>

<details>
  <summary>SSH Agent</summary>

`fish/.config/fish/conf.d/fish-ssh-agent.fish` 处理 ssh-agent，是自定义脚本而非上游插件。每次交互式 shell 都会：

1. source `~/.ssh/agent/env.fish` 继承已有 agent
2. 用 `ssh-add -l` 探测 agent，不可达则用 `ssh-agent -c` 启动新的并持久化到 `env.fish`
3. 若 `id_ed25519` 指纹不在 agent 中则加载它

结果：所有 fish shell 共享**同一个** ssh-agent，重启终端也不受影响。

若异常（agent 挂掉、陈旧 socket 堆积）：

```fish
pkill ssh-agent
rm ~/.ssh/agent/*
# 打开新 shell，脚本会启动干净的 agent
```

> [!NOTE]
> 提交**签名**完全不经过 ssh-agent。如果每次提交都提示输入密码短语，那是签名密钥的问题，不是 agent 的问题。

</details>

<details>
  <summary>macOS：WindowServer 内存泄漏</summary>

已知 macOS 问题，连接多个外接显示器时 WindowServer 可能占用大量 CPU/内存。解决办法是杀掉 WindowServer（会登出系统），重新登录后内存恢复正常。

**用法**：在终端运行 `killws`，然后重新登录。

</details>

<details>
  <summary>macOS：媒体控制键失效</summary>

媒体键偶尔因 Chrome、WhatsApp 等应用占用而失效，重新启用：

```shell
launchctl load -w /System/Library/LaunchAgents/com.apple.rcd.plist
```

</details>

<details>
  <summary>macOS：Ethernet 回程</summary>

运行 `flashEthernet` 函数刷新 Ethernet 回程：

```shell
flashEthernet; and echo 'Ethernet backhaul flushed'
speedtest
```

</details>

## Agent 文档

`AGENTS.md`（及 `CLAUDE.md` 符号链接）是仓库中 AI 编码代理的工作契约。根文件涵盖仓库级不变量，每个 stow 包或脚本目录各有自己的文档。它们被跟踪但不参与 stow，不会落到 `~` 下。
