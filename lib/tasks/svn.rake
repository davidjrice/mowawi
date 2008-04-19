desc "Configure Subversion for Rails"
task :configure_for_svn do
  system "svn remove log/*"
  system "svn commit -m 'removing all log files from subversion'"
  system 'svn propset svn:ignore "*.log" log/'
  system "svn update log/"
  
  system "svn remove tmp/*"
  system "svn commit -m 'removing all tmp files from subversion'"
  system 'svn propset svn:ignore "*" tmp/'
  system "svn update tmp/"
  
  system "svn commit -m 'Ignoring all files in /log/ ending in .log'"
  system 'svn propset svn:ignore "*.db" db/'
  system "svn update db/"
  system "svn commit -m 'Ignoring all files in /db/ ending in .db'"
  system "svn move config/database.yml config/database.example"
  system "svn commit -m 'Moving database.yml to database.example to provide a template for anyone who checks out the code'"
  system 'svn propset svn:ignore "database.yml" config/'
  system "svn update config/"
  system "svn commit -m 'Ignoring database.yml'"
end