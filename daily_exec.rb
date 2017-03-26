#! /bin/sh
# -*- ruby -*-
USR=`cat http_user.txt`
PWD=`cat http_passwd.txt`
KEY=`cat api_access_key.txt`
URI=`cat project_uri.txt`

logger -t $0 start.

exec ruby -S -x "$0" "${USR}" "${PWD}" "${KEY}" "${URI}" "$@"

#! ruby
# -*- coding: utf-8 -*-
require 'syslog'
require './daily_ticket_generator'

t = Daily_Ticket_Generator.new
t.username = ARGV[0]
t.password = ARGV[1]
t.api_key  = ARGV[2]
t.pj_uri   = ARGV[3]
t.setup_file = 'setup.xml' 

Syslog.open($0)
begin
    t.daily_check

    Syslog.log(Syslog::LOG_INFO, "finished.") 
rescue => e
    Syslog.log(Syslog::LOG_INFO, "failed." + e.message)
ensure
    Syslog.close
end

