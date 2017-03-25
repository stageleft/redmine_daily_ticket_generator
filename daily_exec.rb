#! /bin/sh
# -*- ruby -*-
USR=`cat http_user.txt`
PWD=`cat http_passwd.txt`
KEY=`cat api_access_key.txt`
exec ruby -S -x "$0" "${USR}" "${PWD}" "${KEY}" "$@"

#! ruby
# -*- coding: utf-8 -*-
require './daily_ticket_generator'

t = Daily_Ticket_Generator.new
t.username = ARGV[0]
t.password = ARGV[1]
t.api_key  = ARGV[2]
t.pj_uri   = 'https://secure.ex.root-node.net/redmine/projects/takumim-project/'
t.setup_file = 'setup.xml' 

t.daily_check

