# config valid only for current version of Capistrano
#require 'capistrano/rbenv'
require "bundler/capistrano"
require "rvm/capistrano"

server "59.179.133.67", :web, :app, :db, primary: true
set :port, 22
set :application, 'WebAlbums'
set :repo_url, 'https://github.com/A94Sharma/WebAlbums.git'
task :staging do
  set :user, "deployer2"
  set :environment, "staging"

  set :repository, 'https://github.com/A94Sharma/WebAlbums.git'
  set :revision, "origin/master"

  set :domain,    "deployer2@59.179.133.67"
  set :deploy_to, "/home/deployer2/#{environment}/WebAlbums/"
  set :path, "&& source $HOME/.rvm/scripts/rvm"
end

task :production do
  set :user, "ubuntu"
  set :environment, "production"

  set :repository, 'https://github.com/A94Sharma/WebAlbums.git'
  set :domain, "ubuntu@59.179.133.67"
  set :deploy_to, "/home/ubuntu/#{environment}/WebAlbums/"
  set :path, "&& source $HOME/.rvm/scripts/rvm"
end
set :scm, :git
set :branch, "master"
#set :domain,"root@185.159.215.163"
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# Default value for :scm is :git
set :scm, :git

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end