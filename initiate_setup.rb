#! /bin/sh
# -*- ruby -*-
USR=$(cat $(dirname ${0})/http_user.txt)
PWD=$(cat $(dirname ${0})/http_passwd.txt)
KEY=$(cat $(dirname ${0})/api_access_key.txt)
URI=$(cat $(dirname ${0})/project_uri.txt)
exec ruby -S -x "$0" "${USR}" "${PWD}" "${KEY}" ${URI} "$@"

#! ruby
# -*- coding: utf-8 -*-
require_relative 'daily_ticket_generator'

class Daily_Ticket_Initiator < Daily_Ticket_Generator
  def initiate_setup_list
    @limit = 1
    self.get_issue_list
  end
end

t = Daily_Ticket_Initiator.new
t.username = ARGV[0]
t.password = ARGV[1]
t.api_key  = ARGV[2]
t.pj_uri   = ARGV[3]

t.initiate_setup_list.write(:indent => 4)

