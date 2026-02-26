#!/bin/bash

bunx playwright install
composer setup
sed -i "s|^APP_URL=.*|APP_URL=https://9000-$WEB_HOST|" .env
sed -i "s|^ASSET_URL=.*|ASSET_URL=https://9000-$WEB_HOST|" .env
sed -i "s|^HMR_HOST=.*|HMR_HOST=5173-$WEB_HOST|" .env
sed -i 's|="''${APP_NAME}"|=Laravel|g' .env
echo "alias test='bun run build && mv public/hot public/hot-bak && xvfb-run composer test && mv public/hot-bak public/hot && rm -r public/build'" > ~/.bash_aliases
