Capistrano.configuration(:must_exist).load do

  # http://jonmagic.com/assets/2007/2/21/jonmagic_recipes.txt
  desc "Installs and configures nginx"
  task :setup_nginx do
    install_nginx
    configure_nginx
  end
  
  desc "installs nginx"
  task :install_nginx do
    apt.install({:base => ['nginx']}, :stable)
  end
  
  desc "configures nginx server"
  task :configure_nginx do
    require 'erb'
    buffer = ERB.new(File.read("lib/recipes/nginx.conf")).result(binding)
    temporary_location = "/tmp/nginx.conf"
    put buffer, temporary_location
    run "sudo cp #{temporary_location} /etc/nginx/nginx.conf"
    run "rm #{temporary_location}"
  end
  
  task :start_nginx do
    sudo '/etc/init.d/nginx start'
  end
 
  task :restart_nginx do
    sudo '/etc/init.d/nginx restart'
  end
 
  task :stop_nginx do
    sudo '/etc/init.d/nginx stop'
  end

end