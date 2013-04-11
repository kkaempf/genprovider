$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Genprovider
  INSTANCE_MASK = 1
  METHOD_MASK = 2
  ASSOCIATION_MASK = 4
  INDICATION_MASK = 8
  
  def self.classmask klass
    c = klass
    mask = 0
    while c
      mask |= INSTANCE_MASK if c.instance?
      mask |= METHOD_MASK if c.method?
      mask |= ASSOCIATION_MASK if c.association?
      mask |= INDICATION_MASK if c.indication?
      c = c.parent
    end
    if mask == 0
      STDERR.puts "Assuming that #{klass.name} defines an Instance"
      mask |= INSTANCE_MASK
    end
    mask
  end

  require 'genprovider/version'
  require 'genprovider/output'
  require 'genprovider/class'
  require 'genprovider/provider'
  require 'genprovider/registration'
  require 'genprovider/testcase'
  require 'genprovider/classinfo'
  require 'genprovider/rdoc'
end