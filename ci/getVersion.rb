#! /usr/bin/env ruby

require 'cocoapods-core'

puts Pod::Spec.from_file('./LigerMobile.podspec').source[:tag]
