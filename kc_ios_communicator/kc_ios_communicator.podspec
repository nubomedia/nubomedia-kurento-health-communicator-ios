#
# Be sure to run `pod lib lint kc_ios_communicator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'kc_ios_communicator'
  s.version          = '0.1.0'
  s.summary          = 'A short description of kc_ios_communicator.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/<GITHUB_USERNAME>/kc_ios_communicator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jvinaches' => 'jvinaches@naevatec.com' }
  s.source           = { :git => 'https://github.com/<GITHUB_USERNAME>/kc_ios_communicator.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'kc_ios_communicator/**/*.{h,m}'

  s.resource_bundles = {'kc_ios_communicator' => ['kc_ios_communicator/*.xcdatamodeld']}

  # s.resource_bundles = {
  #   'kc_ios_communicator' => ['kc_ios_communicator/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'

  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.frameworks = 'Foundation', 'Security', 'CFNetwork', 'CoreData'
  s.library = 'icucore'

  s.dependency 'AFNetworking'
  s.dependency 'OCMapper'
  s.dependency 'kc_ios_pojo'
  s.dependency 'KurentoToolboxMod'
  s.dependency 'Reachability', '~> 3.2'

  s.subspec 'KurentoToolboxMod' do |ss|
    ss.source_files = '../Kurento-iOS/Classes/KurentoToolbox.h'
    #ss.ios.vendored_frameworks = '../../../Kurento-iOS-master/WebRTC.framework'
  end


  s.subspec 'kc_ios_pojo' do |ss|
        ss.source_files = '../kc_ios_pojo/kc_ios_pojo/**/*.{h,m}'
        # ss.resource = '../kc_ios_pojo/Classes/resources/*.*'
        ss.dependency 'JSONModel'
  end

end
