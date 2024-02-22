Pod::Spec.new do |s|
    s.name             = 'Extensions'
    s.version          = '0.1.0'
    s.summary          = 'AgoraSenseTimeExtension'
    s.description      = 'project.description'
    s.homepage         = 'https://github.com/AgoraIO-Community/AgoraMarketPlace'
    s.author           = { 'Agora' => 'developer@agora.io' }
    s.source           = { :path => '.' }
    s.vendored_frameworks = 'AgoraSenseTimeExtension.framework'
    s.platform = :ios, '9.0'
  end
  