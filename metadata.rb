name             "radicale"
maintainer       "Abel Lopez"
maintainer_email "alopgeek@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures radicale"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{ ubuntu }.each do |os|
  supports os
end
