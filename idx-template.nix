{ pkgs, kit ? "blade-kit", ... }: {
    channel = "stable-25.05";
    packages = [
      pkgs.nodejs_latest
      pkgs.bun
      pkgs.j2cli
      pkgs.curl
    ];

    bootstrap = ''
      echo "#!/bin/sh" > clear
      chmod +x clear
      export PATH="$PWD:$PATH"

      /bin/bash -c "$(curl -fsSL https://php.new/install/linux)"
      export PATH="/home/user/.config/herd-lite/bin:$PATH"

      ${
        if kit == "livewire" then "composer create-project laravel/blank-livewire-starter-kit \"$out\" --stability=dev"
        else if kit == "blade-strict" then "composer create-project nunomaduro/laravel-starter-kit --prefer-dist \"$out\""
        else if kit == "react" then "composer create-project laravel/blank-react-starter-kit \"$out\" --stability=dev"
        else if kit == "react-strict" then "composer create-project nunomaduro/laravel-starter-kit-inertia-react --prefer-dist \"$out\""
        else if kit == "vue" then "composer create-project laravel/blank-vue-starter-kit \"$out\" --stability=dev"
        else if kit == "vue-strict" then "composer create-project nunomaduro/laravel-starter-kit-inertia-vue --prefer-dist \"$out\""
        else if kit == "svelte" then "composer create-project laravel/blank-svelte-starter-kit \"$out\" --stability=dev"
        else "composer create-project laravel/laravel \"$out\" --remove-vcs --prefer-dist --no-scripts"
      }

      mkdir -p "$out"/.idx
      j2 ${./devNix.j2} -o "$out/.idx/dev.nix"
      
      cd "$out"

      sed -i 's/\("php": "[^0-9]*\)8\.[0-9]\+/\18.4/' composer.json

      echo "" >> .env.example
      echo 'ASSET_URL="''${APP_URL}"' >> .env.example
      echo "" >> .env.example
      echo "HMR_HOST=" >> .env.example
      echo "HMR_PORT=443" >> .env.example
      echo "HMR_PROTOCOL=wss" >> .env.example

      cp .env.example .env

      composer setup
      composer update

      cat <<EOF > patch-vite.ts
      import { readFileSync, writeFileSync, existsSync } from "fs";

      const fileName = existsSync("vite.config.ts") ? "vite.config.ts" : "vite.config.js";
      
      if (!existsSync(fileName)) {
          console.error("Could not find vite.config.js or .ts");
          process.exit(0); // Exit gracefully if neither exists
      }

      let content = readFileSync(fileName, "utf-8");

      if (!content.includes("process.loadEnvFile();")) {
          content = content.replace("export default defineConfig({", "process.loadEnvFile();\\n\\nexport default defineConfig({");
      }

      const hmrBlock = "        hmr: {\\n" +
                       "            host: process.env.HMR_HOST,\\n" +
                       "            clientPort: parseInt(process.env.HMR_PORT || \'\'),\\n" +
                       "            protocol: process.env.HMR_PROTOCOL,\\n" +
                       "        },";

      const fullServerBlock = "    server: {\\n" + hmrBlock + "\\n    },";

      if (content.includes("server: {")) {
          content = content.replace("server: {", "server: {\\n" + hmrBlock);
      } else {
          content = content.replace(/\\}\\);\\s*$/, (match) => {
              return fullServerBlock + "\\n" + match;
          });
      }

      writeFileSync(fileName, content);
      EOF

      bun patch-vite.ts
      rm patch-vite.ts
    '';
}
