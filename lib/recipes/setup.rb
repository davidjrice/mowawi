Capistrano.configuration(:must_exist).load do
  
  desc "create deployment group and add current user to it"
  task :setup_user_perms do
    deprec.groupadd(group)
    deprec.add_user_to_group(user, group)
  end

  desc "Changes the sshd config to disable root access via SSH and reloads sshd" 
  task :disable_root_access_via_ssh do
    sudo "sed -i -e 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config" 
    sudo "/etc/init.d/sshd reload" 
  end

  task :setup_admin_account do
    uid = Capistrano::CLI.password_prompt "Enter userid for new user:" 
    deprec.useradd(uid, :shell => '/bin/bash')
    puts "Setting pasword for new account"
    passwd = Capistrano::CLI.password_prompt "Setting pasword for new account:" 
    run "passwd #{uid}"
    deprec.groupadd('admin')
    deprec.add_user_to_group(user, 'admin')
    deprec.append_to_file_if_missing('/etc/sudoers', '%admin ALL=(ALL) ALL')
  end

  task :setup_admin_account_as_root do
    set :user, 'root'
    setup_admin_account
  end

  desc <<-DESC
  setup_rails_host takes a stock standard debian 'etch' server
  and installs everything needed to run howcast
  DESC
  task :install_rails_stack do
    #setup_user_perms
    install_packages_for_rails # install packages that come with distribution
    install_rubygems
    install_gems
    install_image_magick
    install_rmagick
    install_nginx
    setup_smtp_server
  end

  set :rails_debian, {
  :base => %w(build-essential ntp-server mysql-server wget
              ruby irb ri rdoc ruby1.8-dev libopenssl-ruby libmysql-ruby 
              zlib1g-dev zlib1g openssl libssl-dev subversion)
  }

  desc "installs packages required for a rails box"
  task :install_packages_for_rails do
    apt.install(rails_debian, :stable)
  end



  desc "install and configure postfix"
  task :setup_smtp_server do
    install_postfix
    set :postfix_destination_domains, [domain] #+ apache_server_aliases
    #deprec.render_template_to_file('postfix_main', '/etc/postfix/main.cf')
    require 'erb'
    buffer = ERB.new(File.read("lib/recipes/postfix.conf")).result(binding)
    temporary_location = "/tmp/postfix.conf"
    put buffer, temporary_location
    run "sudo cp #{temporary_location} /etc/postfix/main.cf"
    run "rm #{temporary_location}"
  end

  task :install_gems do
    gemify.install 'rails'                 # gem lib makes installing gems fun
    gemify.select 'mongrel'                # mongrel requires we select a version
    gemify.install 'mongrel_cluster'
    gemify.install 'builder'
    gemify.install 'rspec'
  end

  # TODO make this work
  task :install_rubygems do
    # XXX should check for presence of ruby first!
    version = 'rubygems-0.9.2'
    set :src_package, {
      :file => version + '.tgz',
      :md5sum => 'cc525053dd465ab6e33af382166fa808  rubygems-0.9.2.tgz',
      :dir => version,
      :url => "http://rubyforge.org/frs/download.php/17190/#{version}.tgz",
      :unpack => "tar zxf #{version}.tgz;",
      :install => '/usr/bin/ruby1.8 setup.rb;'
    }
    deprec.download_src(src_package, src_dir)
    deprec.install_from_src(src_package, src_dir)
    gemify.upgrade
    gemify.update_system
  end

  desc "installs image magick packages"
  task :install_image_magick do
    apt.install({:base => ['imagemagick', 'libmagick9-dev']}, :stable)
  end

  desc "installs sudo"
  task :install_sudo do
    set :user, 'root'
    apt.install({:base => ['sudo']}, :stable)
  end

  desc "install the rmagic gem, and dependent image-magick library"
  task :install_rmagick, :roles => [:app, :web] do
    gemify.install 'rmagick'
  end

  desc "install postfix and dependent packages"
  task :install_postfix do
    apt.install({:base => ['postfix']}, :stable)
  end

  desc "Copy database.yml from local application to remote shared/config"
  task :setup_db_config, :except => { :no_release => true } do
    put(File.read('config/database.yml'),"#{shared_path}/config/database.yml", :mode => 0444)
  end
  
  desc "Set up the expected application directory structure on all boxes"
  task :setup, :except => { :no_release => true } do

    run <<-CMD
      mkdir -p -m 777 #{deploy_to}
      sudo chown #{user}:#{user} #{deploy_to}
      mkdir -p -m 775 #{releases_path} #{shared_path}/system &&
      mkdir -p -m 777 #{shared_path}/log &&
      mkdir -p -m 777 #{shared_path}/pids &&
      mkdir -p -m 777 #{shared_path}/config &&
      mkdir -p -m 777 #{shared_path}/sessions
    CMD
    setup_db_config
  end

end