# -*- coding: utf-8 -*-
# vim: ft=sls
# Manage service for service fail2ban
{%- from "fail2ban/map.jinja" import fail2ban with context %}
{%- set iptables = salt['pillar.get']('iptables') %}

fail2ban_service:
 service.{{ fail2ban.service.state }}:
   - name: {{ fail2ban.service.name }}
   - enable: {{ fail2ban.service.enable }}
   - watch:
       - file: fail2ban_config
       - file: fail2ban_jail_conf
       - file: fail2ban_default_conf
{% if iptables.enabled is defined and iptables.enabled and iptables.service.enable %}
       - service: iptables_service
{% endif %}
