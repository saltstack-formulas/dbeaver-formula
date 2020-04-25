# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import dbeaver with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

dbeaver-package-archive-install:
  pkg.installed:
    - names: {{ dbeaver.pkg.deps|json }}
  file.directory:
    - name: {{ dbeaver.pkg.archive.name }}
    - user: {{ dbeaver.rootuser }}
    - group: {{ dbeaver.rootgroup }}
    - mode: 755
    - makedirs: True
    - require_in:
      - archive: dbeaver-package-archive-install
    - recurse:
        - user
        - group
        - mode
  archive.extracted:
    {{- format_kwargs(dbeaver.pkg.archive) }}
    - retry: {{ dbeaver.retry_option|json }}
    - user: {{ dbeaver.rootuser }}
    - group: {{ dbeaver.rootgroup }}

dbeaver-archive-install-file-symlink:
  file.symlink:
    - name: {{ dbeaver.linux.symlink }}
    - target: {{ dbeaver.pkg.archive.name }}/{{ dbeaver.command }}
    - force: True
    - require:
      - archive: dbeaver-package-archive-install
    - unless:
      - {{ dbeaver.linux.altpriority|int > 0 }}
      - {{ grains.os_family|lower in ('windows', 'arch') }}
