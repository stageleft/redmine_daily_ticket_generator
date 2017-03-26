#! /bin/sh
# -*- ruby -*-
USR=`cat http_user.txt`
PWD=`cat http_passwd.txt`
KEY=`cat api_access_key.txt`
URI=`cat project_uri.txt`
exec ruby -S -x "$0" "${USR}" "${PWD}" "${KEY}" ${URI} "$@"

#! ruby
# -*- coding: utf-8 -*-
require './daily_ticket_generator'

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

