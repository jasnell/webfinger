## webfinger.rb

A simple Ruby WebFinger JRD implementation

Getting Started:
```
gem install webfinger-jrd
```

Or building from source...
```
git clone git://github.com/jasnell/webfinger.git
gem build webfinger.gemspec
gem install webfinger-jrd-0.0.1.gem
```

Note: The webfinger gem has currently only been tested on Ruby 1.9.3

Example: 
 
``` ruby
#!/Users/james/.rvm/rubies/ruby-1.9.3-p194/bin/ruby
##############################################
# Author: James M Snell (jasnell@gmail.com)  #
# License: Apache v2.0                       #
##############################################

require 'wfjrd'
include WebFinger

STDOUT << jrd { 
  pretty
  subject 'acct:me@here.com'
  expires now + 1.day
  aka [
    'http://example.com',
    'http://example.net'
  ]  
  properties {
    property 'http://example.org', 'foo'
  }
  link {
    rel  'avatar'
    href 'http://example.org/i.jpg'
    type 'image/jpeg'
    titles { 
      lang    'en-US', 'foo'
      default 'foo'
    }
  }
}
```

