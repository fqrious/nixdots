{ lib, pkgs, ... }:
{
  home.activation.installYtDlp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export UV_TOOL_BIN_DIR="$HOME/.local/share/bin"
    export UV_TOOL_DIR="$HOME/.local/share/uv/tools"
    mkdir -p "$UV_TOOL_BIN_DIR" "$UV_TOOL_DIR"
    ${pkgs.uv}/bin/uv tool install --upgrade yt-dlp
  '';
}
