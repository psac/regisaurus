require 'bundler/capistrano'
require 'rvm/capistrano'
load 'deploy/assets'

set :application, 'regisaurus'
set :applicationdir, "/home/pi/apps/#{application}"
set :repository, 'git@gibson.bkmhosting.com:regisaurus'
set :branch, 'master'
set :user, 'pi'
set :use_sudo, false

set :rvm_ruby_string, :local
before 'deploy', 'rvm:create_gemset'

server 'pi', :app, :web, :db, primary: true

set :deploy_to, applicationdir
set :deploy_via, :export

after 'deploy', 'deploy:migrate'
after 'deploy:restart', 'deploy:cleanup'

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Symlink shared configs and folders on each release."
  task :symlink_db do
    run "ln -nfs #{shared_path}/db/development.sqlite3 #{release_path}/db/development.sqlite3"
  end
end

after 'deploy:update_code', 'deploy:symlink_db'
