require 'json'

# Returns the version number for a package.json file
package = JSON.parse(File.read('./package.json'))

Pod::Spec.new do |s|
  s.name             = 'RNNearBee'
  s.version          = package["version"]
  s.description      = 'A wrapper for NearBee.'
  s.summary          = 'Components for RNNearBee.'
  s.homepage         = 'https://github.com/Beaconstac/react-native-nearbee'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Beaconstac' => 'support@beaconstac.com' }
  s.source           = { :git => 'https://github.com/Beaconstac/react-native-nearbee', :tag => s.version }

  s.source_files   = "ios/*.{h,m}"
  s.platform       = :ios, '10.0'

  # React is split into a set of subspecs, these are the essentials
  s.dependency 'React-Core'
  s.dependency 'React-cxxreact'
  s.dependency 'React-RCTAnimation'
  s.dependency 'React-RCTImage'
  s.dependency 'React-RCTLinking'
  s.dependency 'React-RCTNetwork'
  s.dependency 'React-RCTText'

  # React's dependencies
  s.dependency 'yoga'
  podspecs = [
    '../react-native/third-party-podspecs/DoubleConversion.podspec',
    '../react-native/third-party-podspecs/Folly.podspec',
    '../react-native/third-party-podspecs/glog.podspec'
  ]
  
  s.dependency 'NearBee', '~> 0.2.4'
end
