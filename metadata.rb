name             'company-news'
maintainer       "Shaun O'Keefe"
maintainer_email 'shaun.okeefe.0@gmail.com'
license          'MIT'
description      'Installs and configures company-news'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

supports 'ubuntu'

depends 'java'
depends 'nginx'
depends 'tomcat'
