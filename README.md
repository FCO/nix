# Nix macOS – FCO

Uma configuração Nix para macOS usando flakes, nix-darwin, Home Manager e nix-homebrew — ajustada para o host `FCO` (Apple Silicon) e usuário `fernando`.

## Sobre

Este repositório declara: sistema (nix-darwin), Homebrew de forma declarativa (nix-homebrew) e ambiente do usuário (Home Manager), incluindo shell, Git, Neovim e ferramentas de desenvolvimento. Baseado no template "Nix macOS Starter", com adaptações para o host `FCO`.

## Pré‑requisitos

1. Instale o Nix com o instalador da Determinate Systems (GUI para macOS). Reinicie o terminal após a instalação.
2. Homebrew é gerenciado via nix-homebrew. Se já existir, será migrado; caso contrário, será instalado automaticamente.

## Início rápido

1. Coloque este repositório em `~/.config/nix` e entre na pasta.
2. Aplique a configuração:

```bash
# Primeira vez, use o comando direto
sudo darwin-rebuild switch --flake ~/.config/nix#FCO

# Depois, use o atalho
nix-switch
```

- Arquitetura atual: `aarch64-darwin` (Apple Silicon). Em Macs Intel, troque para `"x86_64-darwin"` em `flake.nix` (linha onde `system = "aarch64-darwin"`).

## O que está incluído

- Ferramentas de desenvolvimento (CLI via nixpkgs):
  - Básico: `curl`, `vim` (alias para `nvim`), `htop`, `tree`, `ripgrep`, `zoxide`, `coreutils`
  - Editor: `neovim` (config linkada de repositório externo pinado)
  - Nix/formatters: `nil`, `biome`, `nixfmt-rfc-style`
  - Multimídia/aux.: `yt-dlp`, `ffmpeg`, `ollama`
  - Fontes: `nerd-fonts.fira-code`, `nerd-fonts.fira-mono`
- Aplicativos (GUI via Homebrew casks):
  - Sistema/UX: `aerospace`, `cleanshot`, `hiddenbar`, `raycast`, `betterdisplay`
  - Dev: `wezterm`, `orbstack`
  - Mensageria: `signal`
  - Outros: `1password`, `zen` (browser)
- Homebrew (brews): `docker`, `colima`, `opencode`, `op` (CLI do 1Password); tap `nikitabobko/tap`
- macOS (nix-darwin):
  - Touch ID para `sudo`, ajustes de Finder/Dock/NSGlobalDomain
  - `environment.pathsToLink = [ "/Applications" ]` e PATH com `/opt/homebrew/bin`
  - Usuário principal `fernando` + usuários adicionais (`fernanda`, `sophia`, `aline`) com shell Zsh
- Shell: Zsh com completion, autosuggestion, syntax highlighting e prompt Starship (símbolo λ); aliases úteis (`nix-switch`, `vim`→`nvim` etc.)
- Git: nome/email configurados, LFS habilitado, `init.defaultBranch = main`, `github.user = fernando`
- Neovim: `~/.config/nvim` aponta para repo fixado em commit via `flake.nix`

## Estrutura do projeto

```
~/.config/nix/
├── flake.nix                     # Entradas e saída (darwinConfigurations."FCO")
├── darwin/
│   ├── default.nix               # Integra Home Manager e nix-homebrew; usuários e PATH
│   ├── settings.nix              # Preferências do macOS e Touch ID sudo
│   └── homebrew.nix              # Casks e brews do Homebrew declarativo
├── home/
│   ├── default.nix               # Entrada do Home Manager do usuário
│   ├── packages.nix              # Pacotes CLI e fontes
│   ├── git.nix                   # Configuração do Git
│   ├── shell.nix                 # Zsh + Starship + aliases
│   └── mise.nix                  # (Opcional) Config do Mise
└── hosts/
    └── FCO/
        ├── configuration.nix     # Ajustes específicos do host (ex.: graphite-cli)
        └── shell-functions.sh    # Funções de shell (ex.: cdroot)
```

## Personalização

- Pacotes CLI: edite `home/packages.nix`
- Apps GUI (casks) e brews: edite `darwin/homebrew.nix`
- Preferências do macOS: edite `darwin/settings.nix`
- Shell e prompt: edite `home/shell.nix`
- Git: edite `home/git.nix`
- Neovim: atualize repo/commit em `flake.nix` (variável `nvimRepo`)
- Host `FCO`: adicione itens em `hosts/FCO/configuration.nix` e funções em `hosts/FCO/shell-functions.sh`

### Mise
Mise não está habilitado nesta configuração. Node, Bun, Deno e outras ferramentas podem ser instaladas via nixpkgs ou Homebrew conforme necessário.

Rakudo/Raku é instalado via Homebrew (`rakudo`), e o binário `raku` ficará disponível no PATH.

## Dicas de uso

- Comutação rápida: `nix-switch` (alias para `sudo darwin-rebuild switch --flake ~/.config/nix`)
- Funções de shell: `cdroot` leva à raiz do repositório Git; `nix-clean` roda GC e limpa gerações antigas
- Host FCO instala `graphite-cli` para fluxo de PRs empilhados (`gt`)
- 1Password CLI: instale manualmente via `brew tap 1password/tap && brew install 1password-cli` se desejar usar `op` agora

## Solução de problemas

- "Command not found": reinicie o terminal após o primeiro switch
- Permissão negada: rode com `sudo`
- Apps Homebrew não instalam: verifique PATH para `/opt/homebrew/bin` (já exportado na configuração)
- Git não aplica nome/email: confira `home/git.nix` e reexecute o switch

## Nix Hygiene

- GC automático semanal: `nix.gc` está configurado para apagar gerações com mais de 7 dias
- Substituters: `cache.nixos.org`, `nix-community.cachix.org`, `cache.determinate.systems`
- Trusted keys: configuradas para os substituters acima

## Segredos

- Sops‑nix integrado: pronto para declarar segredos criptografados com `age`
- Próximos passos: gerar chave `age`, criar `secrets/*.yaml` e referenciar via `sops.secrets."name"`

## Créditos

- Template original: Nix macOS Starter por Ben Gubler
- Referências: config do Ethan Niser e tutorial do David Haupt
