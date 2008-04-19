require 'lib/recipes/nginx'
require 'lib/recipes/apt'
require 'lib/recipes/gem'
require 'lib/recipes/ssh'
require 'lib/recipes/deprec'
require 'lib/recipes/mysql'
require 'lib/recipes/nginx'
require 'lib/recipes/setup'
require 'lib/recipes/mongrel'

set :application, "mowawi"


set :deploy_to, "/var/www/app"
set :domain, "mowawi.railsrumble.com"

set :use_sudo, false
set :user, 'deploy'

set :svn_user, 'davidjrice'

set :repository,  "https://#{svn_user}@svn.railsrumble.com/#{application}/tags/rumble_final"


role :app, "64.22.124.248"
role :web, "64.22.124.248"
role :db,  "64.22.124.248", :primary => true

set :src_dir, (defined?(src_dir) ? src_dir : '/usr/local/src') # 3rd party src on servers 

namespace :deploy do
  desc "Update the theme and delete cached files." 
  task :default do
     transaction do
       update_code
       copy_config_files
       symlink
       migrate
     end
     restart
     cleanup
  end
  
  desc "Restart the servers"
  task :restart, :roles => :app do
    restart_mongrel
    restart_nginx
  end
end

set :config_files, %w(database.yml)

desc "Copy configuration files from shared/config to the application"
task :copy_config_files do
  config_files.each do |file|
    run "cp #{shared_path}/config/#{file} #{release_path}/config/"
  end
end