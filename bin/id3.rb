#!/usr/bin/env ruby

# id3.rb
#
# Usage:
#   id3.rb <path/to/music.mp3>
#
# Outputs, in JSON format, a few key id3 tags from the specified mp3 file
#
# Requires:
#   ruby-mp3info (~0.6.13)
#   json (~1.4.3)
#

require 'rubygems'
require 'mp3info'
require 'json'

path = ARGV.first

Mp3Info.open path do |mp3|
  puts JSON.dump({
    :artist => mp3.tag.artist,
    :album  => mp3.tag.album,
    :title  => mp3.tag.title
  })
end
