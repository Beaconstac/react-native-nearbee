require 'json'

# Returns the version number for a package.json file
pkg_version = lambda do |dir_from_root = '', version = 'version'|
  path = File.join(__dir__, dir_from_root, 'package.json')
  JSON.parse(File.read(path))[version]
end

# Let the main package.json decide the version number for the pod
rnnearbee_version = pkg_version.call
# Use the same RN version that the JS tools use
react_native_version = pkg_version.call('../react-native')

Pod::Spec.new do |s|
  s.name             = 'RNNearBee'
  s.version          = rnnearbee_version
  s.description      = 'A wrapper for NearBee.'
  s.summary          = 'Components for RNNearBee.'
  s.homepage         = 'https://github.com/Beaconstac/react-native-nearbee'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Beaconstac' => 'support@beaconstac.com' }
  s.source           = { :git => 'https://github.com/Beaconstac/react-native-nearbee', :tag => s.version.to_s }

  s.source_files   = 'ios/*.{h,m}'
  s.platform       = :ios, '10.0'

  # React is split into a set of subspecs, these are the essentials
  s.dependency 'React/Core', react_native_version
  s.dependency 'React/CxxBridge', react_native_version
  s.dependency 'React/RCTAnimation', react_native_version
  s.dependency 'React/RCTImage', react_native_version
  s.dependency 'React/RCTLinkingIOS', react_native_version
  s.dependency 'React/RCTNetwork', react_native_version
  s.dependency 'React/RCTText', react_native_version

  # React's dependencies
  s.dependency 'yoga', "#{react_native_version}.React"
  podspecs = [
    '../react-native/third-party-podspecs/DoubleConversion.podspec',
    '../react-native/third-party-podspecs/Folly.podspec',
    '../react-native/third-party-podspecs/glog.podspec'
  ]
  podspecs.each do |podspec_path|
    spec = Pod::Specification.from_file podspec_path
    s.dependency spec.name, "#{spec.version}"
  end

  s.dependency 'NearBee', '~> 0.2.0'
end
