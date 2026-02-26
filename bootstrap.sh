#!/bin/bash

echo "#!/bin/sh" > clear
chmod +x clear
export PATH="$PWD:$PATH"

/bin/bash -c "$(curl -fsSL https://php.new/install/linux)"
export PATH="/home/user/.config/herd-lite/bin:$PATH"

case "$kit" in
    "livewire")
        composer create-project laravel/blank-livewire-starter-kit "$out" --stability=dev
        ;;
    "blade-strict")
        composer create-project nunomaduro/laravel-starter-kit --prefer-dist "$out"
        ;;
    "react")
        composer create-project laravel/blank-react-starter-kit "$out" --stability=dev
        ;;
    "react-strict")
        composer create-project nunomaduro/laravel-starter-kit-inertia-react --prefer-dist "$out"
        ;;
    "vue")
        composer create-project laravel/blank-vue-starter-kit "$out" --stability=dev
        ;;
    "vue-strict")
        composer create-project nunomaduro/laravel-starter-kit-inertia-vue --prefer-dist "$out"
        ;;
    "svelte")
        composer create-project laravel/blank-svelte-starter-kit "$out" --stability=dev
        ;;
    *)
        composer create-project laravel/laravel "$out" --remove-vcs --prefer-dist --no-scripts
        ;;
esac

mkdir -p "$out/.idx"
cp setup.sh "$out/.idx/"
j2 ./devNix.j2 -o "$out/.idx/dev.nix"
bun ./patch-vite.ts "$out"

cd "$out"

echo "" >> .env.example
echo 'ASSET_URL="''${APP_URL}"' >> .env.example
echo "" >> .env.example
echo "HMR_HOST=" >> .env.example
echo "HMR_PORT=443" >> .env.example
echo "HMR_PROTOCOL=wss" >> .env.example

cp .env.example .env
sed -i 's/\("php": "[^0-9]*\)8\.[0-9]\+/\18.4/' composer.json
composer setup
composer update

