#! /bin/sh
# -*- ruby -*-
USR=$(cat $(dirname ${0})/http_user.txt)
PWD=$(cat $(dirname ${0})/http_passwd.txt)
KEY=$(cat $(dirname ${0})/api_access_key.txt)
URI=$(cat $(dirname ${0})/project_uri.txt)
exec ruby -S -x "$0" "${USR}" "${PWD}" "${KEY}" "${URI}" "$@"

#! ruby
# -*- coding: utf-8 -*-
require_relative 'daily_ticket_generator'

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
t.pj_uri   = ARGV[3]
t.setup_file = File.dirname(__FILE__) + '/setup.xml'

puts t.validate_setup_list

