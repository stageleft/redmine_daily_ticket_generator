#! /bin/sh
# -*- ruby -*-
USR=`cat http_user.txt`
PWD=`cat http_passwd.txt`
KEY=`cat api_access_key.txt`
exec ruby -S -x "$0" "${USR}" "${PWD}" "${KEY}" "$@"

#! ruby
# -*- coding: utf-8 -*-
require './daily_ticket_generator'

class Daily_Ticket_Validator < Daily_Ticket_Generator
  def validate_setup_list
    self.get_setup_list
    @issue_list = REXML::Document.new()
    @issue_list << REXML::XMLDecl.new('1.0', 'UTF-8')
    @issue_list.add_element("issues")
    self.generate_issues
  end
end

t = Daily_Ticket_Validator.new
t.username = ARGV[0]
t.password = ARGV[1]
t.api_key  = ARGV[2]
t.pj_uri   = 'https://secure.ex.root-node.net/redmine/projects/takumim-project/'
t.setup_file = 'setup.xml' 

t.validate_setup_list

