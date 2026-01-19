# Changelog

## 1.0.4 - 2026-01-19

### Added

- Added Ruby gem `irb`.

### Changed

- Updated Ruby to 3.3.
- Changed the way to install Ruby:
    - Replaced download and make with `dnf install`.

### Removed

- Deleted `config/gemrc` file.

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
