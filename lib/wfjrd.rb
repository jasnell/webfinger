##############################################
# Author: James M Snell (jasnell@gmail.com)  #
# License: Apache v2.0                       #
#                                            #
# A simple WebFinger JRD implementation.     #
##############################################
REQUIRED_VERSION = '1.9.3'
raise "The webfinger gem currently requires Ruby version #{REQUIRED_VERSION} or higher" if RUBY_VERSION < REQUIRED_VERSION
require 'wfjrd/wfjrd'
