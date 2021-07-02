# Changelog

All notable changes to this project will be documented in this file.

## Release 2.2.0

**Features**
- Changed default version to [mailhog v1.0.1](https://github.com/mailhog/MailHog/releases/tag/v1.0.1).
- Added convenience parameters `mailhog::service_ip` and `mailhog::service_port` to control both public addresses of the API Service (`mailhog::api_bind_addr_ip`, `mailhog::api_bind_addr_port`) and HTTP Service (`mailhog::ui_bind_addr_ip`, `mailhog::ui_bind_addr_port`). Default remain as `0.0.0.0` and `8025`
- New parameter `mailhog::manage_curl: true` to manage the deinstallation of `curl`.
  
  When the `mailhog` module is asked to ensure its absence with
```
mailhog::ensure: absent
# added: don't remove curl, even if no other module requires it.
mailhog::manage_curl: false
```
  then `$manage_curl` does no longer try to uninstall curl.

**Bugfixes**
- Notify the running mailhog service when the mailhog binary is updated.
- Fix runtime issue with `Service[mailhog]`, when `{ensure => stopped, enable => true}`.

**Known Issues**
- none

## Release 2.1.0 (2020-03-06)

**Features**
- Allow to set `{ensure:absent}` to remove the module from a machine
- replaced deprecated methods with stdlib's `validate_legacy` function

## Release 2.0.0  (2020-02-26)

**Features**
- Import module from https://github.com/ftaeger[ftaeger] and major upgrades of tests including fixes
- Added support for Debian 8,9, 10
