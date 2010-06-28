require 'rubygems'
require 'json'

token = JSON.parse(`fsclient lock`)["data"]
bytes = JSON.parse(`fsclient --token=#{token} download 0x40003000 48`)['data']

puts bytes.pack("c"*48) # Interpret as 48 characters
