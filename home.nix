{
  config,
  pkgs,
  ...
}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "aragao";
    homeDirectory = "/home/aragao";
    stateVersion = "23.11";

    sessionVariables = {
      # Wayland support for Electron applications
      NIXOS_OZONE_WL = "1";

      # General Wayland environment
      XDG_SESSION_TYPE = "wayland";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      CLUTTER_BACKEND = "wayland";

      # Mozilla/Firefox Wayland support
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_WEBRENDER = "1";

      # SDL and Java Wayland support
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";

      # Make Nix applications visible to application launchers
      XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      la = "ls -A";
      l = "ls -CF";
      cd = "z";
      ".." = "z ..";
      "..." = "z ../..";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline";
      gd = "git diff";
      gb = "git branch";
      gco = "git checkout";
      gor = "go run";
      gob = "go build";
      got = "go test";
      gom = "go mod";
      gotidy = "go mod tidy";
      gofmt = "go fmt ./...";

      # Kubectl aliases
      k = "kubectl";
      kgp = "kubectl get pods";
      kgs = "kubectl get services";
      kgd = "kubectl get deployments";
      kgn = "kubectl get nodes";
      kga = "kubectl get all";
      kd = "kubectl describe";
      kdp = "kubectl describe pod";
      kds = "kubectl describe service";
      kdd = "kubectl describe deployment";
      kl = "kubectl logs";
      klf = "kubectl logs -f";
      ke = "kubectl exec -it";
      ka = "kubectl apply -f";
      kdel = "kubectl delete";
      kdelp = "kubectl delete pod";
      kctx = "kubectx";
      kns = "kubens";
      k9 = "k9s";

      # Docker aliases
      d = "docker";
      dc = "docker-compose";
      dps = "docker ps";
      dpa = "docker ps -a";
      di = "docker images";
      drm = "docker rm";
      drmi = "docker rmi";
      dex = "docker exec -it";

      # Terraform aliases
      tf = "terraform";
      tfi = "terraform init";
      tfp = "terraform plan";
      tfa = "terraform apply";
      tfd = "terraform destroy";
      tfv = "terraform validate";
      tff = "terraform fmt";

      # File manager
      y = "yazi";
    };

    shellInit = ''
      set -x GOPATH $HOME/go
      set -x PATH $HOME/.local/bin $GOPATH/bin $PATH
      set -x EDITOR nvim

      # Custom fish greeting with fastfetch and fortune
      function fish_greeting
        fastfetch
        echo ""
        fortune|lolcat
      end
    '';

    functions = {
      mkcd = ''
        mkdir -p $argv[1]
        cd $argv[1]
      '';

      gitclean = ''
        git branch --merged | grep -v "\*\|main\|master\|develop" | xargs -n 1 git branch -d
      '';

      # Kubectl utility functions
      kpf = ''
        if test (count $argv) -lt 2
          echo "Usage: kpf <pod-name> <local-port:remote-port>"
          return 1
        end
        kubectl port-forward $argv[1] $argv[2]
      '';

      kshell = ''
        if test (count $argv) -lt 1
          echo "Usage: kshell <pod-name> [shell]"
          return 1
        end
        set shell $argv[2]
        if test -z "$shell"
          set shell "/bin/bash"
        end
        kubectl exec -it $argv[1] -- $shell
      '';

      kwait = ''
        if test (count $argv) -lt 1
          echo "Usage: kwait <resource/name>"
          return 1
        end
        kubectl wait --for=condition=ready $argv[1] --timeout=300s
      '';
    };

    interactiveShellInit = ''
      # Enable vi key bindings
      fish_vi_key_bindings

      # Custom key bindings
      bind -M insert \cf accept-autosuggestion
    '';
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      command_timeout = 1200;
      scan_timeout = 10;
      format = ''
        [](bold cyan) $directory$cmd_duration$all$kubernetes$azure$docker_context$time
        $character'';
      directory = {home_symbol = " ";};
      golang = {
        #style = "bg:#79d4fd fg:#000000";
        style = "fg:#79d4fd";
        format = "[$symbol($version)]($style)";
        symbol = " ";
      };
      git_status = {
        disabled = true;
      };
      git_branch = {
        disabled = true;
        symbol = " ";
        #style = "bg:#f34c28 fg:#413932";
        style = "fg:#f34c28";
        format = "[  $symbol$branch(:$remote_branch)]($style)";
      };
      azure = {
        disabled = true;
        #style = "fg:#ffffff bg:#0078d4";
        style = "fg:#0078d4";
        format = "[  ($subscription)]($style)";
      };
      java = {
        format = "[ ($version)]($style)";
      };
      kubernetes = {
        #style = "bg:#303030 fg:#ffffff";
        style = "fg:#2e6ce6";
        #format = "\\[[󱃾 :($cluster)]($style)\\]";
        format = "[ 󱃾 ($cluster)]($style)";
        disabled = true;
      };
      docker_context = {
        disabled = false;
        #style = "fg:#1d63ed";
        format = "[ 󰡨 ($context) ]($style)";
      };
      gcloud = {disabled = true;};
      hostname = {
        ssh_only = true;
        format = "<[$hostname]($style)";
        trim_at = "-";
        style = "bold dimmed fg:white";
        disabled = true;
      };
      line_break = {disabled = true;};
      username = {
        style_user = "bold dimmed fg:blue";
        show_always = false;
        format = "user: [$user]($style)";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "aragao";
    userEmail = "aragao@avaya.com"; # Default to work email

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      commit.gpgsign = true;
      tag.gpgsign = true;
      # GPG program will be set automatically by programs.gpg
    };

    # Conditional includes for different directories
    includes = [
      {
        condition = "gitdir:~/projects/personal/";
        contents = {
          user = {
            email = "andrearag@gmail.com";
            signingkey = "74CCE1A4F133BE6F";
          };
        };
      }
      {
        condition = "gitdir:~/projects/work/";
        contents = {
          user = {
            email = "aragao@avaya.com";
            signingkey = "792E9235301AC862";
          };
        };
      }
    ];

    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
    };
  };

  programs.gpg = {
    enable = true;
    settings = {
      # Use AES256 for symmetric encryption
      cipher-algo = "AES256";
      # Use SHA512 for hashing
      digest-algo = "SHA512";
      # Use SHA512 for certifications
      cert-digest-algo = "SHA512";
      # Disable weak digest algorithms
      weak-digest = "SHA1";
      # Use stronger compression
      compress-algo = "2";
      # Disable inclusion of version in output
      no-emit-version = true;
      # Disable comments in output
      no-comments = true;
      # Use long keyids
      keyid-format = "0xlong";
      # Show fingerprints
      with-fingerprint = true;
      # Cross-certify subkeys
      require-cross-certification = true;
      # Use gpg-agent
      use-agent = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableFishIntegration = true;
    pinentry.package = pkgs.pinentry-gtk2;
    defaultCacheTtl = 3600; # 1 hour
    maxCacheTtl = 86400; # 24 hours
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };

  programs.fzf = {
    enable = true;
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style = "numbers,changes,header";
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 100000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-a";

    extraConfig = ''
      # Rose Pine theme
      set -g status-position bottom
      set -g status-bg "#191724"
      set -g status-fg "#e0def4"
      set -g status-left ""
      set -g status-right "#[fg=#9ccfd8,bg=#393552] %Y-%m-%d #[fg=#f6c177,bg=#393552] %H:%M:%S "
      set -g status-right-length 50
      set -g status-left-length 20

      setw -g window-status-current-format " #[fg=#eb6f92,bg=#393552]#I#[fg=#e0def4,bg=#393552] #[fg=#e0def4,bg=#393552]#W #[fg=#c4a7e7,bg=#393552]#F "
      setw -g window-status-format " #[fg=#6e6a86]#I#[fg=#6e6a86] #W #[fg=#6e6a86]#F "

      # Pane borders
      set -g pane-border-style "fg=#393552"
      set -g pane-active-border-style "fg=#9ccfd8"

      # Message colors
      set -g message-style "fg=#e0def4,bg=#393552"
      set -g message-command-style "fg=#e0def4,bg=#393552"

      # Sensible configurations
      set -s escape-time 0
      set -g display-time 4000
      set -g status-interval 5
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",xterm-256color:Tc"

      # Better indexing
      set -g base-index 1
      setw -g pane-base-index 1

      # Renumber windows when a window is closed
      set -g renumber-windows on

      # Easier and faster switching between next/prev window
      bind C-p previous-window
      bind C-n next-window

      # Source config file
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # Better splitting
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Activity monitoring
      setw -g monitor-activity on
      set -g visual-activity on
    '';

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      {
        plugin = tmux-fzf;
        extraConfig = ''
          # Tmux FZF bindings
          set -g @tmux-fzf-launch-key 'C-f'
        '';
      }
      {
        plugin = better-mouse-mode;
        extraConfig = ''
          set -g @scroll-speed-num-lines-per-scroll 1
          set -g @scroll-without-changing-pane on
          set -g @scroll-in-moused-over-pane on
          set -g @emulate-scroll-for-no-mouse-alternate-buffer on
        '';
      }
    ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    extraConfig = ''
      lua << EOF
      ${builtins.readFile ./neovim/persistence.lua}
      ${builtins.readFile ./neovim/lsp.lua}
      ${builtins.readFile ./neovim/completion.lua}
      ${builtins.readFile ./neovim/animate.lua}
      ${builtins.readFile ./neovim/treesitter.lua}
      ${builtins.readFile ./neovim/theme.lua}
      ${builtins.readFile ./neovim/starter.lua}
      ${builtins.readFile ./neovim/illuminate.lua}
      ${builtins.readFile ./neovim/trouble.lua}
      ${builtins.readFile ./neovim/lualine.lua}
      ${builtins.readFile ./neovim/notify.lua}
      ${builtins.readFile ./neovim/noice.lua}
      ${builtins.readFile ./neovim/telescope.lua}
      ${builtins.readFile ./neovim/indentblankline.lua}
      ${builtins.readFile ./neovim/navic.lua}
      ${builtins.readFile ./neovim/symbolsoutline.lua}
      ${builtins.readFile ./neovim/dap.lua}
      ${builtins.readFile ./neovim/conform.lua}
      ${builtins.readFile ./neovim/none-ls.lua}
      ${builtins.readFile ./neovim/oil.lua}
      ${builtins.readFile ./neovim/init.lua}
      ${builtins.readFile ./neovim/mappings.lua}
    '';
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      mgr = {
        show_hidden = false;
        show_symlink = true;
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
      };
      preview = {
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        cache_dir = "";
      };
      opener = {
        edit = [
          {
            run = "nvim \"$@\"";
            block = true;
          }
        ];
        play = [
          {
            run = "mpv \"$@\"";
            orphan = true;
          }
        ];
        open = [
          {
            run = "xdg-open \"$@\"";
            desc = "Open";
          }
        ];
      };
      open = {
        rules = [
          {
            name = "*/";
            use = ["edit" "open"];
          }
          {
            mime = "text/*";
            use = ["edit" "open"];
          }
          {
            mime = "image/*";
            use = ["open"];
          }
          {
            mime = "video/*";
            use = ["play" "open"];
          }
          {
            mime = "audio/*";
            use = ["play" "open"];
          }
          {
            mime = "inode/x-empty";
            use = ["edit" "open"];
          }
        ];
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = ["l"];
          run = "plugin --sync smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = ["g" "g"];
          run = "arrow -99999999";
          desc = "Move cursor to the top";
        }
        {
          on = ["G"];
          run = "arrow 99999999";
          desc = "Move cursor to the bottom";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    go
    gopls
    go-tools
    delve
    gotools
    golangci-lint

    # Nix development tools
    nil
    alejandra

    # Common development tools
    curl
    wget
    jq
    gnupg
    pinentry-gtk2
    ripgrep
    fd
    tree
    htop
    fastfetch
    fortune
    entr
    code-cursor
    vscode
    speedtest-cli
    lolcat
    p7zip
    unrar
    usbutils
    pciutils
    gdu
    yazi

    # Language servers
    nodejs_20
    nodePackages.typescript-language-server
    nodePackages.bash-language-server
    marksman

    # Cloud development tools
    kubectl
    kubernetes-helm
    k9s
    kubectx
    kustomize
    docker
    docker-compose
    terraform
    awscli2
    azure-cli
    google-cloud-sdk

    # File management
    unzip
    zip

    # AI/ML tools
    ollama

    obsidian
    chromium
  ];

  # Nix configuration
  nix = {
    package = pkgs.nix;

    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };

  # Home Manager needs a bit of information about you and the paths it should manage
  programs.home-manager.enable = true;
}
