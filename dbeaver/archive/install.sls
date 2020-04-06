# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import dbeaver with context %}
{%- from tplroot ~ "/jinja/macros.jinja" import format_kwargs with context %}

dbeaver-package-archive-install-extract:
  file.directory:
    - name: {{ dbeaver.pkg.archive.name }}
    - user: {{ dbeaver.rootuser }}
    - group: {{ dbeaver.rootgroup }}
    - mode: 755
    - makedirs: True
    - require_in:
      - archive: dbeaver-package-archive-install-extract
    - recurse:
        - user
        - group
        - mode
  archive.extracted:
    {{- format_kwargs(dbeaver.pkg.archive) }}
    - retry:
        attempts: 3
        until: True
        interval: 60
        splay: 10
    - user: {{ dbeaver.rootuser }}
    - group: {{ dbeaver.rootgroup }}
