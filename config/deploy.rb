# config valid only for current version of Capistrano
require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'rvm/capistrano'
lock '3.4.0'

set :application, 'WebAlbums'
set :repo_url, 'https://github.com/A94Sharma/WebAlbums.git'

set :scm, :git
set :branch, "master"

set :user, "deployer"
set :stages, ["staging", "production"]
set :default_stage, "staging"
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/WebAlbums'
set :deploy_via, :remote_cache
# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle}
# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

# run the db migrations
    task :run_migrations, :roles => :db do
        puts "RUNNING DB MIGRATIONS"
        run "cd #{current_path}; rake db:migrate RAILS_ENV=#{rails_env} --trace"
    end

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

# hook to run db migrations after code update
after("deploy:update", "deploy:run_migrations")
after :finishing, 'deploy:cleanup'
after :finishing, 'deploy:restart'
end