{ pkgs, kit ? "blade-kit", ... }: {
    channel = "stable-25.05";
    packages = [
      pkgs.nodejs_latest
      pkgs.bun
      pkgs.j2cli
      pkgs.curl
    ];
    bootstrap = ''
      cp -rf ${./.}/* .
      ./bootstrap.sh
    '';
}
