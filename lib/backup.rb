#!/usr/bin/ruby
#backup.rb
require 'open-uri'
require 'optparse'
require 'rubygems'
#require 'highline/import'

def get_interval(url)
  begin
    io = open url
    if io.status[0] == "200"
      text = io.gets
      if text =~ /^succeed,\d+$/
        interval = text.split(',')[1]
        return interval.to_i
      end
    end
  rescue
  
  ensure
    return 0
  end
end

def backup(dbname,dbuser,dbkey)
  now = DateTime.now
  timestamp = now.strftime("%Y_%m_%d_%H_%M")
  if dbkey.nil?
    cmd = "mysqldump --databases #{dbname} >> #{timestamp}.txt;"
  else
    cmd = "mysqldump -u #{dbuser} -p#{dbkey} --databases #{dbname} >> #{timestamp}.txt;"
  end
  cmd << "tar -czvf #{dbname+"_" +timestamp}.tag.gz #{timestamp}.txt;"
  cmd << "rm #{timestamp}.txt -f;"
  `#{cmd}`
end

def backup_win32(dbname,dbuser,dbkey)
  now = DateTime.now
  timestamp = now.strftime("%Y_%m_%d_%H_%M")
  cmd = []
  if dbkey.nil?
    cmd << "mysqldump --databases #{dbname} >> #{timestamp}.txt"
  else
    cmd << "mysqldump -u #{dbuser} -p#{dbkey} --databases #{dbname} >> #{timestamp}.txt"
  end
  cmd << "winrar a #{dbname+"_" +timestamp} #{timestamp}.txt"
  cmd << "del #{timestamp}.txt"
  cmd.each do |script|
    `#{script}`
  end
end

def prompt_pwd(prompt='Please input database key:', mask='*')
  if methods.include?('ask')
    ask(prompt) { |q| q.echo = mask }
  else
    puts prompt
    gets
  end
end
  
def main(args)
  url = "http://localhost:3000/data_backup/interval"
  dbname = "cuan"
  dbuser = "root"
  dbkey = nil
  target = nil
  
  gets_pwd = false #是否需要输入密码
  opts = OptionParser.new do |opts|
    opts.banner = "Usage: #$0 [options]"
    opts.on('-d', '--database <STRING>', "name of database, default is #{dbname}") do |string|
      dbname = string
    end
    
    opts.on('-u', '--username <STRING>', "name of database login account, default is #{dbuser}") do |string|
      dbuser = string
    end
    
    opts.on('-p', '--password', 'prompt password') do
      gets_pwd = true
    end
    
    opts.on('-l', '--url <STRING>', "URL for geting backup interval, default is #{url}") do |string|
      url = string || ''
    end

    opts.on('-t', '--target <STRING>', "backup data target path, default is current directory") do |string|
      target = string
    end
    
    opts.on_tail('-h', '--help', 'display this help and exit') do
      puts opts
      exit
    end
  end
  opts.parse!(args)

  if gets_pwd
    dbkey = prompt_pwd.gsub!(/\n/,'')
  end

  Dir.chdir(target) if target

  is_mswin = `ruby -v` =~ /mswin/
  while(true) do
    if is_mswin
      backup_win32(dbname,dbuser,dbkey)
    else
      backup(dbname,dbuser,dbkey)
    end
    interval = 30
    new_interval = get_interval(url)
    unless new_interval == 0
      interval = new_interval
    end
    sleep(interval * 60)
  end
end  

main(ARGV)
