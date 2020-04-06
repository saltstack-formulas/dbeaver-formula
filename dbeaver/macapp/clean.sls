# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/jinja/map.jinja" import dbeaver with context %}

dbeaver-macos-app-clean-files:
  file.absent:
    - names:
      - {{ dbeaver.dir.tmp }}
      - /Applications/DBeaver.app

    {%- else %}

dbeaver-macos-app-clean-unavailable:
  test.show_notification:
    - text: |
        The dbeaver macpackage is only available on MacOS

    {%- endif %}
