# IDX Laravel

This is a simple, ready-to-go template for building Laravel apps inside Firebase Studio.

## ⚡ Supported Starter Kits

The environment automatically detects your choice and provisions the correct architecture using Nix. Choose your flavor:

| Stack | Type | Source Package |
| :--- | :--- | :--- |
| **Blade** | **Strict** | `nunomaduro/laravel-starter-kit` |
| **React** | **Strict** | `nunomaduro/laravel-starter-kit-inertia-react` |
| **Vue** | **Strict** | `nunomaduro/laravel-starter-kit-inertia-vue` |
| **Livewire** | Standard | `laravel/blank-livewire-starter-kit` |
| **React** | Standard | `laravel/blank-react-starter-kit` |
| **Vue** | Standard | `laravel/blank-vue-starter-kit` |
| **Svelte** | Standard | `laravel/blank-svelte-starter-kit` |
| **Laravel Core** | Default | `laravel/laravel` |

## 🚀 Getting Started

Simply click the button below to launch the template directly in Firebase Studio. The environment will load, and you can proceed with the Initial Setup steps.

<a href="https://studio.firebase.google.com/new?template=https%3A%2F%2Fgithub.com%2Ffredikaputra%2Fidx-laravel">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://cdn.firebasestudio.dev/btn/open_dark_32.svg">
    <source
      media="(prefers-color-scheme: light)"
      srcset="https://cdn.firebasestudio.dev/btn/open_light_32.svg">
    <img
      height="32"
      alt="Open in Firebase Studio"
      src="https://cdn.firebasestudio.dev/btn/open_blue_32.svg">
  </picture>
</a>

## 🛠️ Network Configuration

To ensure the environment functions correctly, you must adjust the port visibility in the **Backend Ports** tab. This allows your local browser to communicate with the frontend development tools properly.

**Port**
`5173`

**Visibility**
Change from **Private** to **Public**.

## 🧪 Browser Testing (Pest)

If you want to run browser-based tests, there are two important requirements for the IDX environment:

1. **Virtual Display:** Because the environment is headless, you must prepend your test commands with `xvfb-run` (e.g., `xvfb-run php artisan test`).
2. **Asset Preparation:** Ensure your assets are already built (`bun run build`) and use those static builds instead of running `bun run dev`.

### ⚡ The Shortcut (Recommended)
To make testing comfortable and easy to run, a custom alias has been configured. You can execute everything described above by simply running:

```bash
test
```

> This alias is stored in `~/.bash_aliases`.