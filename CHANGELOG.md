# Changelog

## 1.1 - 2026-02-07

### Added

- Added `config/php.ini` that will be located in `/var/www` to override Apache's `php.ini`
- Added `PHPINIDir` and `SetEnv PHP_INI_SCAN_DIR` in `config/virtualhost.conf`
- New `PHP_VERSION` is handled in `provision.sh`

### Changed

- Modified alias `ll` in `config/bashrc`
- Updated `README.md`

### Removed

- Deleted `config/php.ini.htaccess`
    - `.htaccess` is no longer used to override Apache's `php.ini`
- Removed `:php_error_reporting` from `settings.yaml`
- Removed `PHP_ERROR_REPORTING` from `Vagrantfile`
- Removed `PHP_ERROR_REPORTING_INT` and its handling from `provision.sh`

## 1.0.4 - 2026-01-19

### Added

- Added Ruby gem `irb`.

### Changed

- Changed Adminer theme.
- Made Ruby installation by default.
    - Reverted to default Ruby version.
- Replaced download and make with `dnf install`.

### Removed

- Deleted `config/gemrc` file.
- Removed rbenv and bundler.

## 1.0.3 - 2026-01-16

### Added

- Forwarded port 3000 in `settings.yaml`

### Removed

- Removed SSL certificates and this VM hosting HTTPS localhost
- Removed `:id` to all `:forwarded_ports` except ssh.

## 1.0.2 - 2026-01-15

### Added

- Added `setenforce Permissive` and firewall commands to unblock localhost websites.

### Changed

- Updated YAML array format in `settings.yaml`.
    - Added `:id` to all `:forwarded_ports`.
- Updated `Vagrantfile` by adding local variables.
    - Modernized path in the `YAML.load_file()` call.
- Replaced `FORWARDED_PORT_80` variable with `HOST_HTTP_PORT` in 3 files.
    - Updated `provision.sh`, `adminer.conf`, `virtualhost.conf` with new variable name.
- Modified the version section of `provision.sh` for the section title and the Apache version output.
- Updated the last section of `README.md`.

## 1.0.1 - 2025-10-04

### Added

- Added `CHANGELOG.md`

### Changed

- Updated `README.md`
- Modified `MariaDB.repo` baseurl

### Fixed

- Updated Adminer to version 5+ plugin code and files

## 1.0.0 - 2023-01-14

_First release_
