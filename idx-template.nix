{ pkgs, kit ? "blade-kit", ... }: {
    channel = "stable-25.05";
    packages = [
      pkgs.nodejs_latest
      pkgs.bun
      pkgs.j2cli
      pkgs.curl
      pkgs.git
      pkgs.unzip
    ];
    bootstrap = ''
      export kit="${kit}"
      cp -rf ${./.}/* .
      chmod +x bootstrap.sh
      ./bootstrap.sh
    '';
}
