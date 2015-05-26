# config valid only for current version of Capistrano
#require 'capistrano/rbenv'
require "bundler/capistrano"
require "rvm/capistrano"

server "52.25.225.217", :web, :app, :db, primary: true
set :port, 22
set :application, 'WebAlbums'
set :use_sudo, false
set :rvm_path, "/usr/share/rvm"

task :staging do
  set :user, "deployer2"
  set :environment, "staging"

  set :repository, 'https://github.com/A94Sharma/WebAlbums.git'
  set :revision, "origin/master"

  set :domain,    "deployer2@52.25.225.217"
  set :deploy_to, "/home/deployer2/#{environment}/WebAlbums/"
end

task :production do
  set :user, "ubuntu"
  set :environment, "production"
  set :repository, 'https://github.com/A94Sharma/WebAlbums.git'
  set :domain, "ubuntu@52.25.225.217"
  set :deploy_to, "/home/ubuntu/#{environment}/WebAlbums/"
end
set :scm, :git
set :branch, "master"
set :rvm_type, :system  # Don't use system-wide RVM
default_run_options[:pty] = true
#set :domain,"root@185.159.215.163"
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# Default value for :scm is :git

default_run_options[:pty] = true
task :create_log_share do
  run "mkdir -p #{shared_path}/log"
end
before 'deploy:update', :create_log_share
after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do

    namespace :assets do
      task :precompile, :roles => :web do
        from = source.next_revision(current_revision)
        if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ lib/assets/ app/assets/ | wc -l").to_i > 0
          run_locally("rake assets:clean && rake assets:precompile")
          run_locally "cd public && tar -jcf assets.tar.bz2 assets"
          top.upload "public/assets.tar.bz2", "#{shared_path}", :via => :scp
          run "cd #{shared_path} && tar -jxf assets.tar.bz2 && rm assets.tar.bz2"
          run_locally "rm public/assets.tar.bz2"
          run_locally("rake assets:clean")
        else
          logger.info "Skipping asset precompilation because there were no asset changes"
        end
      end
    end


  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    run "cp #{database_file} #{release_path}/config/database.yml"
    run "cd #{current_path} && RAILS_ENV=#{rails_env} rake db:migrate"
    run "mkdir -p #{shared_path}/config"
    put File.read("#{current_path}/config/database.yml"), "#{shared_path}/config/database.yml"
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

  desc "Install the bundle"
    task :bundle do
      run "bundle install --gemfile #{release_path}/Gemfile --without development test"
  end
  after "deploy:finalize_update", "deploy:bundle"

  desc "Configtest Nginx"
  task "nginx:config", roles: :app do
    run "/etc/init.d/nginx configtest"
  end

  desc "ReStart Nginx"
  task "nginx:restart", roles: :app do
    run "/etc/init.d/nginx restart"
  end
  
  before "deploy", "deploy:check_revision"
end