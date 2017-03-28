#!/bin/sh

sed -i -e "s|RUBYFILE=\$(which ruby)|RUBYFILE=$(which ruby)|" daily_exec.rb

