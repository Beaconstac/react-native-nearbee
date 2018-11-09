require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
s.name           = 'RNNearBee'
s.version        = package['version']
s.summary        = package['description']
s.description    = package['description']
s.license        = package['license']
s.author         = package['author']
s.homepage       = package['homepage']
s.swift_version   = '4.2'
s.source         = { :git => 'https://github.com/Beaconstac/react-native-nearbee.git', :tag => s.version }


s.requires_arc   = true
s.static_framework = true
s.platform       = :ios, '10.0'
s.preserve_paths = 'LICENSE', 'README.md', 'package.json', 'index.js'

s.source_files  = "ios/RNNearBee/*.{h,m}"
s.dependency "React"
s.dependency "NearBee"
end
