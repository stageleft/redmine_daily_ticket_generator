# redmine_daily_ticket_generator
Redmine ticket generator using REST API. auto generate daily, weekly, monthly work.

It can only work for single project and single user.

# install

 1. Install ruby in your Linux.
    This is not Redmine server.
    You can access youre Redmine with this Linux.

 2. clone or export all files to any directory.

 3. setup your setting in these files.

    api_access_key.txt

    project_uri.txt

    setup.xml
    ( see below to write and validate setup.xml )

    basic_auth.txt
    ( or delete basic_auth.txt if your Redmine don't have basic auth )

 4. setup to execute automatically.

  4-1. change daily_exec.rb to execute by cron.
   change RUBYFILE=$(which ruby) to RUBYFILE=/your/path/to/ruby

  4-2. register to cron.
   sample for "crontab -e" : check and set new ticket in 23:00
    0 23 * * * /your/dir/of/daily_ticket_generator/daily_exec.rb

# setup setup.xml

  You need many Redmine internal information to write setup.xml 

  0. check any ticket in your project
     which is incompleted and you are author or assigned.
 
  1. execute command below
     after setup  http_user.txt http_password.txt api_access_key.txt

     $ ./initial_setup.rb > setup.xml.sample

  2. see setup.xml.sample and edit setup.xml

     You need project id, author id and assgned_to id from setup.xml.sample

     You set subject and description as you like.

     You set start_date and due_date in GNU date format.
     before you set, please check below to validate your parameter.

     $ date +%F -d "your-setup-parameter"

     sample 1)
        <start_date>tomorrow</start_date>

     sample 2)
        <due_date>`date '+%Y-%m-28'` 1 months</due_date>

  3. execute command below to validate parameter.

     $ ./validate_setup.rb > setup.xml.sample

# about author

  stageleft ( sugano-github@elder-allance.org )

