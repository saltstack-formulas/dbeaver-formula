# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import dbeaver with context %}

{%- if 'config' in dbeaver and dbeaver.config %}

    {%- if dbeaver.pkg.use_upstream_source %}
        {%- set sls_package_clean = tplroot ~ '.source.clean' %}
    {%- elif dbeaver.pkg.use_upstream_archive %}
        {%- set sls_package_clean = tplroot ~ '.archive.clean' %}
    {%- else %}
        {%- set sls_package_clean = tplroot ~ '.package.clean' %}
    {%- endif %}
include:
  - {{ sls_package_clean }}

dbeaver-config-clean-file-absent:
  file.absent:
    - names:
      - {{ dbeaver.environ_file }}
    - require:
      - sls: {{ sls_package_clean }}
