# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import dbeaver with context %}

dbeaver-package-repo-pkgrepo-absent:
  pkgrepo.absent:
    - name: {{ dbeaver.pkg.repo.name }}
    - onlyif: {{ dbeaver.pkg.repo and dbeaver.pkg.use_upstream_repo }}
