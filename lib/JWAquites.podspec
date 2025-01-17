Pod::Spec.new do |s|

  s.name          = "JWAquites"
  s.version       = "1.0"
  s.summary       = "sdk"
  s.homepage      = "none"
  s.license       = 'MIT'
  s.author        = "Carefree"
  s.source        = { :git => '' }
  s.requires_arc  = true
  s.platform      = :ios, '12.0'

  s.dependency 'AppsFlyerFramework'
  s.dependency 'NTESVerifyCode'
  s.frameworks = 'AVFoundation', 'CoreTelephony', 'SystemConfiguration', 'JavaScriptCore', 'WebKit', 'Security'
  s.vendored_frameworks = '*.xcframework'
  s.libraries = 'resolv', 'c++'
  s.user_target_xcconfig = {
    'OTHER_LDFLAGS' => ['-ObjC', '-fprofile-instr-generate', '-lz'],
    'ENABLE_USER_SCRIPT_SANDBOXING' => 'NO'
  }

end