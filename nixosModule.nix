{
  neovimConfigured,
  vscode,
  ...
}: ({pkgs, ...}: {
  environment.systemPackages = [
    vscode
    (pkgs.writeScriptBin "nvim" ''
      #!/usr/bin/env bash
      if [ -f /run/secrets/openai-api-key ]; then
        export OPENAI_API_KEY=$(cat /run/secrets/openai-api-key)
      else
        echo "No OpenAI API key found in /run/secrets/openai-api-key"
      fi
      exec ${neovimConfigured.neovim}/bin/nvim "$@"
    '')
  ];
})
