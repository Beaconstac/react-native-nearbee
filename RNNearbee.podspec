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
s.swift_version  = '4.2'

s.source         = { :git => "https://github.com/Beaconstac/react-native-nearbee.git", :tag => s.version }
s.source_files  = "ios/*.{h,m}"

s.requires_arc   = true

s.dependency 'React/Core'
s.dependency 'NearBee'

end
