$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Genprovider
  VERSION = '0.0.2'
  require 'genprovider/output'
  require 'genprovider/class'
  require 'genprovider/provider'
  require 'genprovider/registration'
end