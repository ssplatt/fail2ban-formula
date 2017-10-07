# -*- coding: utf-8 -*-
# vim: ft=sls
# How to install fail2ban
{%- from "fail2ban/map.jinja" import fail2ban with context %}

fail2ban_pkg:
  pkg.installed:
    - name: {{ fail2ban.pkg }}

{%- if fail2ban.user is defined %}
fail2ban_user:
  user.present:
    - name: {{ fail2ban.user }}
{%- endif %}
