# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import dbeaver with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

dbeaver-package-repo-pkgrepo-managed:
  pkgrepo.managed:
    {{- format_kwargs(dbeaver.pkg.repo) }}
    - onlyif: {{ dbeaver.pkg.repo and dbeaver.pkg.use_upstream_repo }}
