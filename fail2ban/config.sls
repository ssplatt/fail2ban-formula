# -*- coding: utf-8 -*-
# vim: ft=sls
# How to configure fail2ban
{%- from "fail2ban/map.jinja" import fail2ban with context %}

fail2ban_config:
  file.managed:
    - name: '/etc/fail2ban/fail2ban.conf'
    - source: salt://fail2ban/files/{{ grains.oscodename }}/fail2ban.conf.j2
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - config: {{ fail2ban.config }}

fail2ban_jail_conf:
  file.managed:
    - name: /etc/fail2ban/jail.conf
    - source: salt://fail2ban/files/{{ grains.oscodename }}/jail.conf.j2
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - config: {{ fail2ban.jail_conf }}

fail2ban_jail_local_conf:
  file.managed:
    - name: /etc/fail2ban/jail.local
    - source: salt://fail2ban/files/jail.local.j2
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - config: {{ fail2ban.jail_local }}

fail2ban_default_conf:
  file.managed:
    - name: /etc/default/fail2ban
    - source: salt://fail2ban/files/{{ grains.oscodename }}/default-fail2ban.j2
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - config: {{ fail2ban.default }}

{% if fail2ban.filters is defined and fail2ban.filters|length != 0 %}
{% for filter_name, filter_config in fail2ban.filters|dictsort %}
fail2ban_config_filter_{{ filter_name }}:
  file.managed:
    - name: '/etc/fail2ban/filter.d/{{ filter_name }}.conf'
    {% if filter_config.source is defined -%}
    - source: {{ filter_config.source }}
    {% else -%}
    - source: salt://fail2ban/files/filterd.conf.j2
    - config: {{ filter_config }}
    {% endif -%}
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - watch_in:
      - service: fail2ban_service
{% endfor %}
{% endif %}

{% if fail2ban.jaild is defined and fail2ban.jaild|length != 0 %}
{% for jaild_name, jaild_config in fail2ban.jaild|dictsort %}
fail2ban_config_jaild_{{ jaild_name }}:
  file.managed:
    - name: '/etc/fail2ban/jail.d/{{ jaild_name }}.conf'
    - source: salt://fail2ban/files/jaild.conf.j2
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - config: {{ jaild_config }}
    - watch_in:
      - service: fail2ban_service
{% endfor %}
{% endif %}

{% if fail2ban.actiond is defined and fail2ban.actiond != 0 %}
{% for actiond_name, actiond_config in fail2ban.actiond|dictsort %}
fail2ban_config_actiond_{{ actiond_name }}:
  file.managed:
    - name: '/etc/fail2ban/action.d/{{ actiond_name }}.conf'
    - source: salt://fail2ban/files/actiond.conf.j2
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - config: {{ actiond_config }}
    - watch_in:
      - service: fail2ban_service
{% endfor %}
{% endif %}
