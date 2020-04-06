# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import dbeaver with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if dbeaver.environ or dbeaver.config.path %}

    {%- if dbeaver.pkg.use_upstream_source %}
        {%- set sls_package_install = tplroot ~ '.source.install' %}
    {%- elif dbeaver.pkg.use_upstream_archive %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.package.install' %}
    {%- endif %}
include:
  - {{ sls_package_install }}

dbeaver-config-file-managed-environ_file:
  file.managed:
    - name: {{ dbeaver.environ_file }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup='dbeaver-config-file-managed-environ_file'
                 )
              }}
    - mode: 640
    - user: {{ dbeaver.rootuser }}
    - group: {{ dbeaver.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        path: {{ dbeaver.config.path|json }}
        environ: {{ dbeaver.environ|json }}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
