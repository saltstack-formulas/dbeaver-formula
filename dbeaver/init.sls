# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/jinja/map.jinja" import dbeaver with context %}
{%- set p = dbeaver.pkg %}

include:
             {%- if grains.os_family in ('MacOS',) %}
  -{{ ' .macapp' if p.use_upstream_macapp else ' .archive' if p.use_upstream_archive else ' .package' }}

             {%- elif grains.os_family == 'Windows' or p.use_upstream_archive %}
  - .archive

             {%- else %}
  - .package

             {%- endif %}
