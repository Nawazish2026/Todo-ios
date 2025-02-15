platform :ios, '13.0'  # Ensure it's at least 13.0+

target 'Todoey' do
  use_frameworks!

  pod 'RealmSwift', '~> 10.44.0'
  pod 'SwipeCellKit'
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/wowansm/Chameleon.git', :branch => 'swift5'
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0' # Match iOS target
        end
      end
    end
  end
end
