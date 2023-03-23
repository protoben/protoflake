{
  description = "Ben Hamlin's user environment flakes";

  inputs = {
    neovim-flake.url = "github:protoben/neovim-flake";
  };

  outputs = { self, nixpkgs, neovim-flake }:
  let

    # TODO Make this work on macos
    pkgs = nixpkgs.legacyPackages.x86_64-linux;

    neovim = rec {
      modules = {
        base = {
          config.vim.lineNumberMode = "number";
          config.vim.mapLeaderSpace = true;
          config.vim.useSystemClipboard = true;
          config.vim.mouseSupport = "a";
          config.vim.homekeyMovement = true;
        };
        theme = {
          config.vim.theme.enable = true;
          config.vim.theme.name = "moonfly";
        };
        ai = {
          config.vim.ai.enable = true;
        };
        plugins = {
          config.vim = {
            statusline.lualine = {
              enable = true;
              icons = false;
              theme = "auto";
            };

            git = {
              enable = true;
              gitsigns.enable = true;
            };

            markdown = {
              enable = true;
              glow.enable = true;
            };

            visuals = {
              enable = true;
              nvimWebDevicons.enable = true;
              lspkind.enable = true;
              indentBlankline.enable = true;
            };

            tabline.nvimBufferline = {
              enable = true;
            };

            treesitter = {
              enable = true;
              fold = true;
              autotagHtml = true;
            };

            lsp = {
              enable = true;
              formatOnSave = false;
              nix.enable = true;
              rust.enable = true;
              python = true;
              clang = {
                enable = true;
                c_header = true;
              };
              trouble.enable = true;
              lspSignature.enable = true;
            };

            keys = {
              enable = true;
              whichKey.enable = true;
            };

            telescope.enable = true;
          };
        };
      };
      configs = {
        minimal = neovim-flake.lib.neovimConfiguration {
          modules = with modules; [ base theme ];
          inherit pkgs;
        };
        withPlugins = neovim-flake.lib.neovimConfiguration {
          modules = with modules; [ base theme plugins ];
          inherit pkgs;
        };
        ai = neovim-flake.lib.neovimConfiguration {
          modules = with modules; [ base theme plugins ai ];
          inherit pkgs;
        };
      };
    };


  in {

    packages.x86_64-linux.neovim-minimal = neovim.configs.minimal.neovim;
    packages.x86_64-linux.neovim= neovim.configs.withPlugins.neovim;
    packages.x86_64-linux.neovim-ai = neovim.configs.ai.neovim;

  };
}
