# -*- coding: utf-8 -*-
# vim: ft=yaml
# Custom Pillar Data for fail2ban

fail2ban:
  enabled: True
  service: # service state options
    state: running
    enable: True
  config: # /etc/fail2ban/fail2ban.conf options
    logtarget: SYSLOG
    socket: /var/run/fail2ban/fail2ban.sock
    pidfile: /var/run/fail2ban/fail2ban.pid
    {% if grains.oscodename == "jessie" -%}
    loglevel: 3
    {% elif grains.oscodename == "stretch" -%}
    loglevel: INFO
    dbfile: /var/lib/fail2ban/fail2ban.sqlite3
    dbpurgeage: 86400
    syslogsocket: auto
    {%- endif %}
  default: # /etc/default/fail2ban options
    fail2ban_opts: ''
  jails: # old style jails added to jails.conf
    'nginx-internet-filter':
      enabled: true
      port:
        - 'http'
        - 'https'
      filter: 'nginx-internet-filter'
      logpath: '/var/log/nginx/access.log'
      maxretry: 1
      bantime: 86400
      findtime: 86400
  filters: # /etc/fail2ban/filters.d/*.conf files
    'nginx-internet-filter': # file name
      source: 'salt://fail2ban/files/filters/nginx-internet-filter' # template file
    blacklist: # file name
      failregex: 'NOTICE \[sshd\] Ban <HOST>' # options
      ignoreregex: ""
  jaild: # /etc/fail2ban/jail.d/#.conf files
    defaults-debian: # file name
      sshd: # block name
        enabled: true # options
    blacklist: # file name
      blacklist: # block name
        banaction: hostsdeny # options
        logpath: "%(syslog_daemon)s"
        maxretry: 3
        findtime: 43200
        bantime: 31536000
        enabled: true
  actiond: # /etc/fail2ban/action.d/*.conf files
    blacklist: # file name
      Definition: # block name
        actionstart: "" # options
        actionstop: ""
        actioncheck: ""
        actionban: "IP=<ip> && echo \"$IP\n\" >> <file>"
      Init:
        file: /etc/hosts.deny
        daemon_list: ALL
