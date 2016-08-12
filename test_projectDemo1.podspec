Pod::Spec.new do |s|
  s.name         = 'test_projectDemo1'
  s.version      = '<#Project Version#>'
  s.license      = '<#License#>'
  s.homepage     = '<#Homepage URL#>'
  s.authors      = '<#Author Name#>': '<#Author Email#>'
  s.summary      = '<#Summary (Up to 140 characters#>'

  s.platform     =  :ios, '<#iOS Platform#>'
  s.source       =  git: '<#Github Repo URL#>', :tag => s.version
  s.source_files = '<#Resources#>'
  s.frameworks   =  '<#Required Frameworks#>'
  s.requires_arc = true
  
# Pod Dependencies
  s.dependencies =	pod "MJRefresh"
  s.dependencies =	pod "Alamofire", '~> 3.4'
  s.dependencies =	pod "PKHUD"
  s.dependencies =	pod "GPUImage"
  s.dependencies =	pod "PullToRefreshKit"
  s.dependencies =	pod "Kingfisher"        # SDWebImaged的swift版本
  s.dependencies =	pod "QKLockView"

end