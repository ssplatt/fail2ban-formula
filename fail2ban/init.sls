# -*- coding: utf-8 -*-
# vim: ft=sls
# Init fail2ban
{%- from "fail2ban/map.jinja" import fail2ban with context %}

{% if fail2ban.enabled %}
include:
  - fail2ban.install
  - fail2ban.config
  - fail2ban.service
{% else %}
'fail2ban-formula disabled':
  test.succeed_without_changes
{% endif %}
