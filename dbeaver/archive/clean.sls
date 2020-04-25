# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import dbeaver with context %}

dbeaver-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ dbeaver.pkg.archive.name }}
      - {{ dbeaver.dir.tmp }}

dbeaver-package-archive-clean-symlink:
  file.absent:
    - name: {{ dbeaver.linux.symlink }}
    - unless:
      - {{ dbeaver.linux.altpriority|int > 0 }}
      - {{ grains.os_family|lower in ('windows', 'arch') }}
