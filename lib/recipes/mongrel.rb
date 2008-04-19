#require 'mongrel_cluster/recipes'

Capistrano.configuration(:must_exist).load do

  # ----------------------------------------------------------------------------
  # Mongrel
  # ----------------------------------------------------------------------------
  desc "Start the mongrel cluster"
  task :start_mongrel, :roles => :app do
    send(run_method, "cd #{deploy_to}/current && mongrel_rails cluster::start")
  end

  desc "Stop the mongrel cluster"
  task :stop_mongrel, :roles => :app do
    send(run_method, "cd #{deploy_to}/current && mongrel_rails cluster::stop")
  end

  desc "Restart the mongrel cluster"
  task :restart_mongrel, :roles => :app do
    send(run_method, "cd #{deploy_to}/current && mongrel_rails cluster::restart")
  end

  desc "The spinner task is used by :cold_deploy to start the application up"
  task :spinner, :roles => :app do
    start_mongrel
  end

end