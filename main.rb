require 'git'
require 'csv'
require 'fileutils'
require 'travis'
def create_repository()
  File.open('/home/zc/projects/wechat_jump_game/create.sh','w') do |file|
    file.puts 'cd /home/zc/projects/wechat_jump_game'
    file.puts 'pwd'
    file.puts '#!/bin/bash'
    file.puts 'hub create jump1'
    #file.puts '#!/usr/bin/expect'
    #file.puts 'spawn hub create jump1'
    #file.puts 'expect "Enter username:"'
    #file.puts 'send "340355960@qq.com\r"'
    #file.puts 'expect "Enter password:"'
    #file.puts 'send "cumtzc04091751\r"'
    #file.puts 'expect eof'
  end
  %x"chmod 777 /home/zc/projects/wechat_jump_game/create.sh"
  #%x"/home/zc/projects/checkstyle/checkstyle/create.sh"
  `/home/zc/projects/wechat_jump_game/create.sh`
  puts __FILE__
end
def tracis_enable()
  File.open('/home/zc/projects/wechat_jump_game/travis.sh','w') do |file|
    file.puts '#!/bin/bash'
    file.puts 'cd /home/zc/projects/wechat_jump_game'
    file.puts 'travis enable -r zhangch1991425/jump1'
    file.puts 'git remote add jump1 git@github.com:zhangch1991425/jump1.git'
  end
  %x"chmod 777 /home/zc/projects/wechat_jump_game/travis.sh"
  `/home/zc/projects/wechat_jump_game/travis.sh`
end
def git()
  g=Git.open('/home/zc/projects/wechat_jump_game')
  glog=g.log(nil)
  glog.each do |l|
    p l.date

    p l.sha
  end
  g.remotes.each do |l|
    p l
  end
  g.branches.each do |l|
    p l
  end
  #g.push('jump1','bc3af7b8457793aa8d7fbac2cfd8ce0ee1f19d0e')
end

def clone_repo(user_dir,repo_url,repo_dir)
  FileUtils.rm_rf(repo_dir) if File.exist?(repo_dir)
  result=%x"cd #{user_dir} && git clone #{repo_url}"
  p '=================================================================================='
  p result
  p $?
  p '=================================================================================='
  result=%x"cd #{user_dir} && git log"
  p '=================================================================================='
  p result
  p $?
  p '=================================================================================='
end

def create_dir(user_name,repo_name,repo_url,first_sha)
  user_dir=File.join('repositories',user_name)
  repo_dir=File.join('repositories',user_name,repo_name)
  FileUtils.rm_rf(repo_dir) if File.exist?(repo_dir)
  FileUtils.mkdir_p(user_dir) unless File.exist?(user_dir)
  clone_repo(user_dir,repo_url,repo_dir)
  #%x"cd #{user_dir} && git clone #{repo_url}"
=begin
  %x"cd #{repo_dir} && hub create #{user_name}_#{repo_name} && travis enable -r zhangch1991425/#{user_name}_#{repo_name}"
  %x"cd #{repo_dir} && git remote add #{user_name}_#{repo_name} git@github.com:zhangch1991425/#{user_name}_#{repo_name}.git"

  g=Git.open(repo_dir)
  g_log=g.log(nil).between(first_sha,nil)
  g_log.reverse_each do |l|
    puts "#{l.sha}  #{l.date}"
    %x"cd #{repo_dir} && git push #{user_name}_#{repo_name} #{l.sha}:refs/heads/master"
    sleep 60
  end
=end
end

def use_travis(user_name,repo_name,repo_url)
  begin
    travis_repo=Travis::Repository.find("#{user_name}/#{repo_name}")
  rescue Exception=>e
    puts e
    puts "#{user_name},#{repo_name}"
    return
  end
  if travis_repo.last_build && travis_repo.last_build.number.to_i>10
    first_sha=travis_repo.build(1).commit.sha
    create_dir(user_name,repo_name,repo_url,first_sha)
  end
end

def csv_traverse(csv_file)
  CSV.foreach(csv_file,headers:true,col_sep:',') do |row|
    use_travis(row[4],row[2],row[5])
  end
end

csv_traverse('java_github_repo.csv')
=begin
g=Git.open('/home/zc/projects/guava')
g_log=g.log(nil)
g_log.each do |l|
  puts "#{l.sha}  #{l.date}"
  output=%x"cd /home/zc/projects/guava && git branch --contains #{l.sha}"
  puts output
end
=end
