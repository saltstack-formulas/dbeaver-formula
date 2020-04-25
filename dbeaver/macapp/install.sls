# -*- coding: utf-8 -*-
# vim: ft=sls

  {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import dbeaver with context %}

dbeaver-macos-app-install-curl:
  file.directory:
    - name: {{ dbeaver.dir.tmp }}
    - makedirs: True
    - clean: True
  pkg.installed:
    - name: curl
  cmd.run:
    - name: curl -Lo {{ dbeaver.dir.tmp }}/dbeaver-{{ dbeaver.version }} {{ dbeaver.pkg.macapp.source }}
    - unless: test -f {{ dbeaver.dir.tmp }}/dbeaver-{{ dbeaver.version }}
    - require:
      - file: dbeaver-macos-app-install-curl
      - pkg: dbeaver-macos-app-install-curl
    - retry: {{ dbeaver.retry_option|json }}

      # Check the hash sum. If check fails remove
      # the file to trigger fresh download on rerun
dbeaver-macos-app-install-checksum:
  module.run:
    - onlyif: {{ dbeaver.pkg.macapp.source_hash }}
    - name: file.check_hash
    - path: {{ dbeaver.dir.tmp }}/dbeaver-{{ dbeaver.version }}
    - file_hash: {{ dbeaver.pkg.macapp.source_hash }}
    - require:
      - cmd: dbeaver-macos-app-install-curl
    - require_in:
      - macpackage: dbeaver-macos-app-install-macpackage
  file.absent:
    - name: {{ dbeaver.dir.tmp }}/dbeaver-{{ dbeaver.version }}
    - onfail:
      - module: dbeaver-macos-app-install-checksum

dbeaver-macos-app-install-macpackage:
  macpackage.installed:
    - name: {{ dbeaver.dir.tmp }}/dbeaver-{{ dbeaver.version }}
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
    - onchanges:
      - cmd: dbeaver-macos-app-install-curl
  file.append:
    - name: '/Users/{{ dbeaver.rootuser }}/.bash_profile'
    - text: 'export PATH=$PATH:/Applications/DBeaver.app/Contents/MacOS/dbeaver'
    - require:
      - macpackage: dbeaver-macos-app-install-macpackage

    {%- else %}

dbeaver-macos-app-install-unavailable:
  test.show_notification:
    - text: |
        The dbeaver macpackage is only available on MacOS

    {%- endif %}
