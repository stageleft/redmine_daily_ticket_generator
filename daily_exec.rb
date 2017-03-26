#! /bin/sh
# -*- ruby -*-
RUBYFILE=$(which ruby) # change this line
USR=$(cat $(dirname ${0})/http_user.txt)
PWD=$(cat $(dirname ${0})/http_passwd.txt)
KEY=$(cat $(dirname ${0})/api_access_key.txt)
URI=$(cat $(dirname ${0})/project_uri.txt)

logger -t $0 start.

exec ${RUBYFILE} -S -x "$0" "${USR}" "${PWD}" "${KEY}" "${URI}" "$@"

#! ruby
# -*- coding: utf-8 -*-
require 'syslog'
require_relative 'daily_ticket_generator'

t = Daily_Ticket_Generator.new
t.username = ARGV[0]
t.password = ARGV[1]
t.api_key  = ARGV[2]
t.pj_uri   = ARGV[3]
t.setup_file = File.dirname(__FILE__) + '/setup.xml' 

Syslog.open($0)
begin
    t.daily_check

    Syslog.log(Syslog::LOG_INFO, "finished.") 
rescue => e
    Syslog.log(Syslog::LOG_INFO, "failed." + e.message)
ensure
    Syslog.close
end

