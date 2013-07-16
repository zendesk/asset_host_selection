require 'bundler/setup'
$LOAD_PATH <<  File.expand_path('../lib', File.dirname(__FILE__))
require 'asset_host_selection'
require 'rack/response'
require 'rack/mock'
require 'minitest/autorun'
require 'purdytest'
