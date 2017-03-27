#! /bin/sh
# -*- ruby -*-
RUBYFILE=$(which ruby) # change this line
if [ -e $(dirname ${0})/basic_auth.txt ] ; then
    USR=$(head -n 1 $(dirname ${0})/basic_auth.txt)
    PWD=$(tail -n 1 $(dirname ${0})/basic_auth.txt)
else
    USR=__nil__
    PWD=__nil__
fi
KEY=$(cat $(dirname ${0})/api_access_key.txt)
URI=$(cat $(dirname ${0})/project_uri.txt)

logger -t $0 start.

exec ${RUBYFILE} -S -x "$0" "${USR}" "${PWD}" "${KEY}" "${URI}" "$@"

#! ruby
# -*- coding: utf-8 -*-
require 'syslog'
require_relative 'daily_ticket_generator'

t = Daily_Ticket_Generator.new
if '__nil__' == ARGV[0] then
  t.username = nil
else
  t.username = ARGV[0]
end
if '__nil__' == ARGV[1] then
  t.password = nil
else
  t.password = ARGV[1]
end
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

