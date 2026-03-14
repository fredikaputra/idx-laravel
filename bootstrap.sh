#!/bin/bash

echo "#!/bin/sh" >clear
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
"api")
    git clone --depth 1 https://github.com/juststeveking/kit "$out" && rm -rf "$out/.git"
    ;;
"wave")
    curl -LO https://devdojo.com/wave/download && unzip download && mv thedevdojo-wave-* "$out"
    ;;
*)
    composer create-project laravel/laravel "$out" --remove-vcs --prefer-dist --no-scripts
    ;;
esac

mkdir -p "$out/.idx"
cp setup.sh "$out/.idx/"
j2 ./devNix.j2 -o "$out/.idx/dev.nix"

if [[ "$kit" == "wave" ]]; then
    cp setup-wave.sh "$out/.idx/setup.sh"
else
    cp setup.sh "$out/.idx/"
fi

echo "DEBUG: kit variable is [$kit]" >&2
echo "DEBUG: out variable is [$out]" >&2

if [[ "$kit" == "wave" ]]; then
    echo "DEBUG: Condition met. Copying setup-wave.sh..." >&2
    cat setup-wave.sh
else
    echo "DEBUG: Condition NOT met. Copying setup.sh..." >&2
    cat setup.sh
fi

echo 'the copied'
cat "$out/.idx/setup.sh"

exit 1

[[ $kit != "api" ]] && bun ./patch-vite.ts "$out"

cd "$out"

if [[ "$kit" != "api" ]]; then
    echo "" >>.env.example
    echo 'ASSET_URL="''${APP_URL}"' >>.env.example
    echo "" >>.env.example
    echo "HMR_HOST=" >>.env.example
    echo "HMR_PORT=443" >>.env.example
    echo "HMR_PROTOCOL=wss" >>.env.example
fi

cp .env.example .env

# if [[ "$kit" != "wave" ]]; then
#     sed -i 's/\("php": "[^0-9]*\)8\.[0-9]\+/\18.4/' composer.json
#     composer setup
#     composer update
# fi

# [[ $kit == "filament" ]] && composer require filament/filament && php artisan filament:install --panels
