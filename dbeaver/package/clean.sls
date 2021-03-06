# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import dbeaver with context %}

    {%- if grains.os_family == 'Debian' and dbeaver.pkg.use_upstream_repo %}

include:
  - .repo.clean

dbeaver-package-remove-pkg-removed:
  pkg.removed:
    - name: {{ dbeaver.pkg.name }}
    - reload_modules: true

    {%- elif grains.os_family == 'MacOS' %}

dbeaver-package-remove-cmd-run-cask:
  cmd.run:
    - name: brew cask remove {{ dbeaver.pkg.name }}
    - runas: {{ dbeaver.rootuser }}
    - onlyif: test -x /usr/local/bin/brew

    {%- elif grains.kernel|lower == 'linux' %}

dbeaver-package-remove-cmd-run-snap:
  cmd.run:
    - name: snap remove {{ dbeaver.pkg.name }}
    - onlyif: test -x /usr/bin/snap || test -x /usr/local/bin/snap

    {%- endif %}
