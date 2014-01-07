#Pystatsd recipe 

##Source
This recipe install https://github.com/sivy/pystatsd from the .deb package.  
TODO : generate the package within the recipe

##Attribute

    default["graphite"]["pystatsd"]["type"] : Graphite/Ganglia (only graphite is handle)
    default["graphite"]["pystatsd"]["port"] : Listen port
    default["graphite"]["pystatsd"]["pct"] : Pct Threashold
    default["graphite"]["pystatsd"]["flush_intervalle"] : Intervall in millisecond
    default["graphite"]["pystatsd"]["user"] : User to run pystatsd

##Template

Pystatd on Debian is launch over init.  

* Init start script  : init_pystatsd.erb => /etc/init/pystatsd.conf    
* Default values : default_pystatsd => /etc/default/pystatsd  

##Recipe
The recipe install required packages and set pystatsd service to on.  
It require a graphite node if `node["graphite"]["pystatsd"]["type"] = "graphite"`

##Usage
Just add the recipe to a role.

