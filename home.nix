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
      # Editor configuration
      EDITOR = "nvim";
      VISUAL = "nvim";

      # Wayland support for Electron applications
      NIXOS_OZONE_WL = "1";

      # General Wayland environment
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland";
      CLUTTER_BACKEND = "wayland";

      # Mozilla/Firefox Wayland support
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_WEBRENDER = "1";

      # SDL and Java Wayland support
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";

      # Java development environment
      JAVA_HOME = "${pkgs.jdk17}";
      JAVA_OPTS = "-Xmx4g -XX:+UseG1GC";

      # Python warnings configuration
      PYTHONWARNINGS = "ignore::FutureWarning";
      
      # UV configuration
      UV_PYTHON_DOWNLOADS = "never";

      # Make Nix applications visible to application launchers
      XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";

      # Bitwarden configuration
      BW_SESSION = "";
      BW_CLIENTSECRET = "";
      BW_URL = "https://vw.faragao.net"; # Your custom Bitwarden server
      BW_USER = "andre@faragao.net"; # Your Bitwarden email
      # Note: You can also use 'bwserver <url>' command to configure the server dynamically
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "eza -lh --group-directories-first --icons=auto";
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
      y = "yazi";
      qb = "qutebrowser";
      qbw = "qutebrowser --temp-window";
      qbp = "qutebrowser --private";
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza -lh --group-directories-first --icons=auto";
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

      # Java development aliases
      jc = "javac";
      jr = "java";
      jd = "javadoc";
      jp = "javap";
      jh = "javah";
      jps = "jps";
      jstack = "jstack";
      jmap = "jmap";
      jstat = "jstat";
      mvn = "mvn";
      gradle = "gradle";
      spring = "spring";

      # File manager
      y = "yazi";

      # Browser shortcuts
      qb = "qutebrowser";
      qbw = "qutebrowser --temp-window";
      qbp = "qutebrowser --private";

      # Bitwarden CLI shortcuts
      bw = "bitwarden";
      bwl = "bitwarden login";
      bws = "bitwarden sync";
      bwg = "bitwarden get";
      bwc = "bitwarden create";
      bwe = "bitwarden edit";
      bwd = "bitwarden delete";
    };

    shellInit = ''
      set -x GOPATH $HOME/go
      set -x PATH $HOME/.nix-profile/bin $HOME/.local/bin $GOPATH/bin /nix/var/nix/profiles/default/bin $PATH
      set -x EDITOR nvim

      # Custom fish greeting with fastfetch and fortune
      function fish_greeting
        #fastfetch
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

      # Bitwarden utility functions
      bwlogin = ''
        echo "🔐 Logging into Bitwarden..."
        echo "Server: $BW_URL"
        echo "User: $BW_USER"
        bitwarden login --raw
        if test $status -eq 0
          echo "✅ Login successful!"
          echo "🔄 Syncing with server..."
          bitwarden sync
        else
          echo "❌ Login failed"
        end
      '';

      bwsearch = ''
        if test (count $argv) -lt 1
          echo "Usage: bwsearch <search-term>"
          return 1
        end
        echo "🔍 Searching Bitwarden for: $argv[1]"
        bitwarden list items --search $argv[1]
      '';

      bwget = ''
        if test (count $argv) -lt 1
          echo "Usage: bwget <item-name>"
          return 1
        end
        echo "🔑 Getting credentials for: $argv[1]"
        bitwarden get item $argv[1]
      '';

      bwpass = ''
        if test (count $argv) -lt 1
          echo "Usage: bwpass <item-name>"
          return 1
        end
        echo "🔑 Getting password for: $argv[1]"
        bitwarden get password $argv[1] | tr -d '\n' | wl-copy
        echo "✅ Password copied to clipboard!"
      '';

      bwserver = ''
        if test (count $argv) -lt 1
          echo "Usage: bwserver <server-url>"
          echo "Example: bwserver https://vault.company.com"
          return 1
        end
        echo "🔧 Configuring Bitwarden server: $argv[1]"
        bitwarden config server $argv[1]
        if test $status -eq 0
          echo "✅ Server configured successfully!"
          echo "🔄 Syncing with new server..."
          bitwarden sync
        else
          echo "❌ Failed to configure server"
        end
      '';

      bwstatus = ''
        echo "🔍 Bitwarden Status:"
        echo "Server: $(bitwarden config server)"
        echo "User: $(bitwarden config user)"
        echo "Sync Status: $(bitwarden sync --last)"
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
      directory = {
        home_symbol = " ";
      };
      golang = {
        #style = "bg:#79d4fd fg:#000000";
        style = "fg:#79d4fd";
        format = "[$symbol($version)]($style)";
        symbol = " ";
      };
      git_status = {
        disabled = false;
      };
      git_branch = {
        disabled = false;
        symbol = " ";
        #style = "bg:#f34c28 fg:#413932";
        style = "fg:#f34c28";
        format = "[  $symbol$branch(:$remote_branch)]($style)";
      };
      azure = {
        disabled = false;
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
        disabled = false;
      };
      docker_context = {
        disabled = false;
        #style = "fg:#1d63ed";
        format = "[ 󰡨 ($context) ]($style)";
      };
      gcloud = {
        disabled = true;
      };
      hostname = {
        ssh_only = true;
        format = "<[$hostname]($style)";
        trim_at = "-";
        style = "bold dimmed fg:white";
        disabled = true;
      };
      line_break = {
        disabled = true;
      };
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
        condition = "gitdir:/home/aragao/projects/personal/";
        contents = {
          user = {
            email = "andrearag@gmail.com";
            signingkey = "74CCE1A4F133BE6F";
          };
        };
      }
      {
        condition = "gitdir:/home/aragao/projects/work/";
        contents = {
          user = {
            name = "andrearagao";
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
    sshKeys = [
      # Work key authentication subkey (keygrip: 13128BA224F28F0BF32C4015BB454EA017882BE4)
      "13128BA224F28F0BF32C4015BB454EA017882BE4"
      # Personal key main key with authentication capability (keygrip: 5E9AE8F42CC14E0DDFD195A13BC562A1659F9E42)
      "5E9AE8F42CC14E0DDFD195A13BC562A1659F9E42"
    ];
  };

  programs.ssh = {
    enable = true;
    controlMaster = "no";
    controlPath = "none";
    extraConfig = ''
      # GitHub work account
      Host github-work
        HostName github.com
        User git

      # GitHub personal account
      Host github-personal
        HostName github.com
        User git

      # Default GitHub (work account)
      Host github.com
        HostName github.com
        User git
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
    #prefix = "C-b";

    extraConfig = ''
      # Rose Pine theme
      set -g status-position top
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
      #bind | split-window -h -c "#{pane_current_path}"
      #bind - split-window -v -c "#{pane_current_path}"

      # Activity monitoring
      setw -g monitor-activity on
      set -g visual-activity on

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
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
            use = [
              "edit"
              "open"
            ];
          }
          {
            mime = "text/*";
            use = [
              "edit"
              "open"
            ];
          }
          {
            mime = "image/*";
            use = ["open"];
          }
          {
            mime = "video/*";
            use = [
              "play"
              "open"
            ];
          }
          {
            mime = "audio/*";
            use = [
              "play"
              "open"
            ];
          }
          {
            mime = "inode/x-empty";
            use = [
              "edit"
              "open"
            ];
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
          on = [
            "g"
            "g"
          ];
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
    nixfmt

    # OpenGL and graphics libraries
    mesa
    libGL
    libGLU
    freeglut
    glew
    glfw
    vulkan-loader
    vulkan-tools
    # Additional graphics utilities
    glxinfo
    mesa-demos
    # Additional graphics support
    libgbm
    xorg.xdriinfo
    # Wayland graphics support
    wayland
    wayland-protocols
    weston

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
    claude-code
    vscode
    speedtest-cli
    lolcat
    p7zip
    unrar
    usbutils
    pciutils
    gdu
    yazi
    cacert

    # Language servers
    nodejs_20
    nodePackages.typescript-language-server
    nodePackages.bash-language-server
    marksman
    python3Packages.python-lsp-server
    
    # Python development with uv
    uv
    python3

    # Fonts
    fira-code

    # Java development tools
    jdk17
    maven
    gradle
    spring-boot-cli
    lombok

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
    tilt
    mkcert
    istioctl

    # File management
    unzip
    zip
    wl-clipboard

    # AI/ML tools
    ollama

    obsidian
    neovide

    # Password Management
    bitwarden-cli
    bitwarden
    bottom
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
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # Systemd services
  systemd.user = {
    services.notes-sync = {
      Unit = {
        Description = "Auto-sync notes repository";
        After = ["graphical-session.target"];
      };
      Service = {
        Type = "oneshot";
        WorkingDirectory = "/home/aragao/projects/work/notes";
        Environment = [
          "SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh"
          "PATH=${pkgs.git}/bin:${pkgs.openssh}/bin:${pkgs.libnotify}/bin:${pkgs.coreutils}/bin"
          "DISPLAY=:0"
        ];
        ExecStart = pkgs.writeShellScript "notes-sync" ''
          #!/bin/bash
          set -e

          cd /home/aragao/projects/work/notes

          # Check for both tracked changes and untracked files
          if ! git diff-index --quiet HEAD -- || [ -n "$(git ls-files --others --exclude-standard)" ]; then
            echo "Changes detected, committing and pushing..."

            # Add all changes (including untracked files)
            git add -A

            # Commit with timestamp
            git commit -m "Auto-sync: $(date)"

            # Push to remote
            git push

            echo "Notes synced successfully at $(date)"
            notify-send "📝 Notes Sync" "Notes synced successfully at $(date '+%H:%M')" --urgency=low
          else
            echo "No changes detected at $(date)"
            # No notification when no changes
          fi
        '';
      };
    };

    timers.notes-sync = {
      Unit = {
        Description = "Auto-sync notes repository timer";
      };
      Timer = {
        OnCalendar = "*:0/15"; # Every 15 minutes
        Persistent = true;
      };
      Install = {
        WantedBy = ["timers.target"];
      };
    };
  };

  # Home Manager needs a bit of information about you and the paths it should manage
  programs.home-manager.enable = true;

  # Chromium configuration with Vimium and Bitwarden plugins
  programs.chromium = {
    enable = true;
    extensions = [
      # Vimium - The Hacker's Browser
      "dbepggeogbaibhgnhhndojpepiihcmeb"
      # Bitwarden - Password Manager
      "nngceckbapebfimnlniiiahkandclblb"
    ];
  };

  # Cursor configuration with automatic extension management
  # Using programs.vscode since Cursor is VS Code-based
  programs.vscode = {
    enable = true;
    package = pkgs.code-cursor;

    # Automatically install and configure extensions
    # Perfectly aligned with CLI tools installed via Nix
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # Nix development (matches: nil, alejandra)
      jnoortheen.nix-ide

      # Go development (matches: go, gopls, go-tools, delve, golangci-lint)
      golang.go

      # Language servers (matches: typescript-language-server, bash-language-server, marksman)
      zainchen.json
      redhat.vscode-yaml

      # Cloud development (matches: kubectl, helm, docker, terraform, aws, azure, gcloud)
      ms-azuretools.vscode-docker
      ms-kubernetes-tools.vscode-kubernetes-tools
      hashicorp.terraform

      # Web development (matches: nodejs_20)
      bradlc.vscode-tailwindcss
      esbenp.prettier-vscode

      # Java development (comprehensive Java tooling)
      redhat.java
      vscjava.vscode-java-debug
      vscjava.vscode-java-test
      vscjava.vscode-java-dependency
      vscjava.vscode-maven
      vscjava.vscode-gradle

      # Neovim keybindings (for consistent editing experience)
      vscodevim.vim

      # vscode-neovim for full Neovim experience
      asvetliakov.vscode-neovim

      # UI enhancements
      pkief.material-icon-theme
    ];

    # User settings that will be automatically applied
    profiles.default.userSettings = {
      "nix.enable" = true;
      "nix.serverPath" = "nil";
      "nix.formatterPath" = "nixfmt";
      "nix.serverSettings.nil.formatting.command" = ["nixfmt"];
      "nix.serverSettings.nil.diagnostics.ignored" = [
        "unused_binding"
        "unused_with"
      ];

      # Alternative formatter options (you can change the above to use alejandra instead)
      # "nix.formatterPath" = "alejandra";
      # "nix.serverSettings.nil.formatting.command" = ["alejandra"];

      "files.associations" = {
        "*.nix" = "nix";
        "flake.lock" = "json";
        "*.flake" = "nix";
      };

      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
      "editor.codeActionsOnSave.source.fixAll" = "explicit";
      "editor.codeActionsOnSave.source.organizeImports" = "explicit";
      "editor.rulers" = [
        80
        100
      ];
      "editor.tabSize" = 2;
      "editor.insertSpaces" = true;
      "editor.detectIndentation" = false;

      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline" = true;

      "search.exclude" = {
        "**/result" = true;
        "**/result-*" = true;
        "**/.git" = true;
        "**/node_modules" = true;
        "**/target" = true;
        "**/dist" = true;
        "**/build" = true;
      };

      "files.exclude" = {
        "**/result" = true;
        "**/result-*" = true;
        "**/.git" = true;
        "**/node_modules" = true;
        "**/target" = true;
        "**/dist" = true;
        "**/build" = true;
      };

      "terminal.integrated.defaultProfile.linux" = "fish";
      "terminal.integrated.profiles.linux.fish.path" = "/home/aragao/.nix-profile/bin/fish";
      "terminal.integrated.profiles.linux.fish.args" = ["-l"];
      "terminal.integrated.profiles.linux.bash.path" = "/usr/bin/bash";
      "terminal.integrated.profiles.linux.bash.args" = ["-l"];

      "workbench.colorTheme" = "Default Dark+";
      "workbench.iconTheme" = "material-icon-theme";

      "git.enableSmartCommit" = true;
      "git.autofetch" = true;
      "git.confirmSync" = false;

      "go.useLanguageServer" = true;
      "go.toolsManagement.checkForUpdates" = "local";
      "go.formatTool" = "goimports";
      "go.lintTool" = "golangci-lint";
      "go.lintOnSave" = "package";
      "go.vetOnSave" = "package";
      "go.testOnSave" = false;
      "go.coverOnSave" = false;
      "go.buildOnSave" = "package";
      "go.installDependenciesWhenBuilding" = true;
      "go.gopath" = "/home/aragao/go";
      "go.gocodeAutoBuild" = false;

      "terraform.languageServer.enabled" = true;
      "terraform.languageServer.args" = ["serve"];
      "terraform.format.enabled" = true;
      "terraform.format.formatOnSave" = true;
      "terraform.format.ignoreExtensionsOnSave" = [".tfsmurf"];

      "yaml.format.enable" = true;
      "yaml.format.singleQuote" = false;
      "yaml.format.bracketSpacing" = true;
      "yaml.format.proseWrap" = "preserve";
      "yaml.validate" = true;
      "yaml.schemas" = {
        "https://json.schemastore.org/github-workflow.json" = ".github/workflows/*.{yml,yaml}";
        "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" = "**/docker-compose*.{yml,yaml}";
        "https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/kubernetes.json" = "**/*.k8s.{yml,yaml}";
      };

      # Java development settings
      "java.home" = "";
      "java.configuration.updateBuildConfiguration" = "automatic";
      "java.compile.nullAnalysis.mode" = "automatic";
      "java.format.settings.url" = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml";
      "java.format.settings.profile" = "GoogleStyle";

      # Vim keybindings
      "vim.useSystemClipboard" = true;
      "vim.hlsearch" = true;
      "vim.incsearch" = true;
      "vim.ignorecase" = true;
      "vim.smartcase" = true;
      "vim.easymotion" = true;
      "vim.leader" = "<space>";
      "vim.whichwrap" = "b,s,h,l,<,>,[,]";
      "vim.wrap" = true;
      "vim.visualbell" = true;
      "vim.errorbells" = false;

      # Language server settings (aligned with CLI tools)
      "typescript.preferences.includePackageJsonAutoImports" = "auto";
      "typescript.suggest.autoImports" = true;
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "typescript.preferences.importModuleSpecifier" = "relative";

      # Bash language server (matches: bash-language-server)
      "bashIde.path" = "bash-language-server";

      # Markdown language server (matches: marksman)
      "markdown.preview.breaks" = true;
      "markdown.preview.linkify" = true;

      # Kubernetes settings (matches: kubectl, helm, k9s)
      "vs-kubernetes.kubectl-path" = "kubectl";
      "vs-kubernetes.helm-path" = "helm";
      "vs-kubernetes.minikube-path" = "minikube";
      "vs-kubernetes.outputFormat" = "yaml";

      # vscode-neovim configuration with performance optimizations
      "vscode-neovim.enable" = true;
      "vscode-neovim.useWSL" = false;
      "vscode-neovim.highlightGroups.highlights" = [];

      # Performance optimizations for vscode-neovim
      "vscode-neovim.affinity" = "default";
      "vscode-neovim.performance" = {
        "enable" = true;
        "affinity" = "default";
        "maxBufferLines" = 10000;
        "maxBufferSize" = 1000000;
        "maxFileSize" = 1000000;
      };

      # Disable built-in Vim to prevent conflicts with vscode-neovim
      "vim.enabled" = false;

      # Disable automatic updates for Cursor
      "update.mode" = "none";
      "update.showReleaseNotes" = false;
      "extensions.autoUpdate" = false;
      "extensions.autoCheckUpdates" = false;

      # Editor line numbers
      "editor.lineNumbers" = "relative";
    };
  };
}
