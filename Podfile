# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def share_pod
  pod 'lottie-ios', '3.5.0'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'R.swift', '6.1.0'
  pod 'SDWebImage'
  pod 'IQKeyboardManager'
  pod 'Toast-Swift', '~> 5.0.1'
end

target 'TestMovie' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for TestMovie
  share_pod
  target 'TestMovieTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TestMovieUITests' do
    # Pods for testing
  end

end
