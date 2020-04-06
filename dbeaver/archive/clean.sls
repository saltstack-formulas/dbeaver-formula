# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import dbeaver with context %}

dbeaver-cli-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ dbeaver.pkg.archive.name }}
      - {{ dbeaver.dir.tmp }}
