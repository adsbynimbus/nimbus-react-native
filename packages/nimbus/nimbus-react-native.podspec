require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "nimbus-react-native"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/timehop/nimbus-react-native.git", :tag => "#{s.version}" }
  s.source_files = "ios/**/*.{h,m,mm,swift}"

  s.dependency "React-Core"
  s.dependency 'NimbusSDK/NimbusKit'
  s.dependency 'NimbusSDK/NimbusRenderStaticKit'
  s.dependency 'NimbusSDK/NimbusRenderVideoKit'

  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
