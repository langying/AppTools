Pod::Spec.new do |s|
  s.name        = 'AppTools'
  s.version     = '1.0.0'
  s.author      = {'hanqiong' => 'langying.hq@taobao.com'}
  s.license     = {:type => 'BSD'}
  s.source      = {:git  => 'http://gitlab.alibaba-inc.com/langying.hq/AppTools.git', :tag => s.version.to_s}
  s.summary     = 'basic ios developer tools.'
  s.homepage    = 'http://gitlab.alibaba-inc.com/langying.hq/AppTools'
  s.description = 'basic ios developer tools with lots of categories.'

  s.platform      = :ios
  s.requires_arc  = true
  s.resources     = 'AppTools/**/*.bundle'
  s.frameworks    = 'UIKit', 'AVFoundation', 'CoreGraphics'
  s.ios.deployment_target = '8.0'

  s.public_header_files = [
    'AppTools/**/*.h',
  ]

  s.source_files = [
    'AppTools/**/*.{h,hpp,c,m,mm,cpp}',
  ]

  s.dependency 'FMDB',                '~> 2.6.2'
  s.dependency 'Base64nl',            '~> 1.2'
  s.dependency 'SDWebImage',          '~> 3.7.5'
  s.dependency 'AFNetworking',        '~> 3.1.0'
  s.dependency 'MBProgressHUD',       '~> 0.9.2'
  s.dependency 'UIAlertView-Blocks',  '~> 1.0'

end