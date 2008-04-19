desc "Sets up pound config file"
task :write_pound_config do
buffer = render(:template => <<POUNDCONFIG)
User        "ponos" 
Group       "ponos" 
LogLevel    2
Alive       30

ListenHTTP
    Address 0.0.0.0
    Port    80
End

Service
    # Lighty for flv
    URL ".*.flv" 
    BackEnd 
        Address 127.0.0.1
        Port    8000    
    End
End

Service
    # Mongrels
    BackEnd 
        Address 127.0.0.1
        Port    8001    
    End     
    BackEnd
        Address 127.0.0.1
        Port    8002
    End
    BackEnd
        Address 127.0.0.1
        Port    8003
    End
    Session
        Type    BASIC
        TTL     300
    End
End
POUNDCONFIG
put buffer, "/home/ponos/pound.conf", :mode => 0755
run "sudo mv -f /home/ponos/pound.conf /etc/pound.conf"  
end

desc "Sets up pound control script for starting, stopping, and restarting"
task :write_poundctrl_script do  
  buffer = render(:template => <<POUNDCTRL)
#!/bin/sh                                                                                            

#
# Pound control script
#

POUND_CONF=/etc/pound.conf
PIDFILE=/var/run/pound.pid
 
case "$1" in
    start)
      # Starts the Pound deamon                                                                         
      echo "Starting Pound"
      /usr/local/sbin/pound -f $POUND_CONF
 
  ;;
    stop)
      # stops the daemon bt cat'ing the pidfile                                                            
        echo "Stopping Pound"
        killall -9 pound
      #kill `cat $PIDFILE`
  ;;
    restart)
          ## Stop the service regardless of whether it was                                                     
          ## running or not, start it again.                                                                   
          echo "Restarting Pound"
      $0 stop
      $0 start
  ;;
    reload)
      # reloads the config file by sending HUP                                                             
          echo "Reloading config"
      kill -HUP `cat $PIDFILE`
  ;;
    *)
      echo "Usage: poundctrl (start|stop|restart|reload)"
      exit 1
  ;;
esac
POUNDCTRL
  
  put buffer, "/home/ponos/poundctrl", :mode => 0755
  run "sudo mv -f /home/ponos/poundctrl /etc/poundctrl"
end
