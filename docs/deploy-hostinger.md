# Deploying to Hostinger

The `main` branch is deployed to Hostinger after the CI job succeeds. The workflow
builds the production assets and Composer dependencies on GitHub, uploads a
release over SSH, runs database migrations, and points the website's public
directory at the release. The production `.env` file and Laravel storage remain
on the server between deployments.

## 1. Prepare Hostinger

1. In hPanel, select PHP 8.3 or later and enable the PHP extensions required by
   the application, including `gmp`, `pdo_mysql`, `mbstring`, `fileinfo`, `gd`,
   `intl`, and `zip`.
2. Enable SSH access and add a public SSH key. Keep its private key for the
   GitHub secret in the next section.
3. Create a private application directory outside the website's public
   directory. For example:

   ```text
   /home/USER/domains/DOMAIN/laravel-app
   ```

   The website's public directory is commonly:

   ```text
   /home/USER/domains/DOMAIN/public_html
   ```

   Use the actual absolute paths shown by your Hostinger account. The application
   directory and public directory must not contain one another.
4. Create the shared directory, then create the production environment file at
   `<application-directory>/shared/.env` using hPanel File Manager or SSH:

   ```sh
   mkdir -p /home/USER/domains/DOMAIN/laravel-app/shared
   ```

   Configure at least:

   ```dotenv
   APP_ENV=production
   APP_DEBUG=false
   APP_URL=https://your-domain.example
   DB_CONNECTION=mysql
   DB_HOST=your-hostinger-database-host
   DB_PORT=3306
   DB_DATABASE=your-database
   DB_USERNAME=your-database-user
   DB_PASSWORD=your-database-password
   ```

   Create the MySQL database and user in hPanel first. Do not commit this file
   or put its values in GitHub variables. If `APP_KEY` is empty, the first
   successful deployment generates it and retains it in this file.

The workflow uses SSH rather than hPanel's file-only Git deployment because it
must build the Vite assets, install Composer dependencies, and run Laravel
commands. See [Hostinger's Git deployment documentation](https://docs.hostinger.com/websites/git).

## 2. Configure GitHub

In the repository's **Settings → Secrets and variables → Actions**, add these
repository variables:

| Variable | Value |
| --- | --- |
| `HOSTINGER_HOST` | SSH host or IP shown in hPanel |
| `HOSTINGER_USER` | SSH username shown in hPanel |
| `HOSTINGER_SSH_PORT` | SSH port shown in hPanel |
| `HOSTINGER_APP_PATH` | Absolute private application directory |
| `HOSTINGER_PUBLIC_PATH` | Absolute website public directory |

Add these repository secrets:

| Secret | Value |
| --- | --- |
| `HOSTINGER_SSH_KEY` | Private key corresponding to the public key added in hPanel |
| `HOSTINGER_KNOWN_HOSTS` | Verified SSH host-key line for the Hostinger SSH server |

Verify the SSH server fingerprint before saving its host key; do not disable SSH
host-key verification. Never share or commit the private key or production
`.env` values.

## 3. Deploy

Push or merge a change to `main`. GitHub Actions runs CI first and deploys only
if CI passes. The deployment runs `php artisan migrate --force` on every
successful deployment, so back up the production database before the first
deploy and before schema changes.

The site must use the configured public directory as its document root. On the
first deployment, ensure that `<public-directory>/storage` does not already
exist as a real directory; the workflow creates it as a symlink to Laravel's
persistent public storage.
