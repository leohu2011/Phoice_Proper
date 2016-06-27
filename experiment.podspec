Pod::Spec.new do |s|
  s.name         = 'experiment'
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
  s.dependencies =	pod 'SDWebImage'
  s.dependencies =	pod 'MWPhotoBrowser'
  s.dependencies =	pod 'MZTimerLabel'
  s.dependencies =	pod 'FDWaveformView'
  s.dependencies =	pod 'SCSiriWaveformView'
  s.dependencies =	pod 'TheAmazingAudioEngine'
  s.dependencies =	pod 'CTAssetsPickerController'
  s.dependencies =	pod 'DZNPhotoPickerController'
  s.dependencies =	pod 'AFNetworking'
  s.dependencies =	pod 'DZNEmptyDataSet'
  s.dependencies =	pod 'JASwipeCell'
  s.dependencies =	pod 'FMDB/FTS'   # FMDB with FTS
  s.dependencies =	pod 'FMDB/standalone'   # FMDB with latest SQLite amalgamation source
  s.dependencies =	pod 'FMDB/standalone/FTS'   # FMDB with latest SQLite amalgamation source and FTS
  s.dependencies =	pod 'FMDB/SQLCipher'   # FMDB with SQLCipher

end