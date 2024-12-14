Pod::Spec.new do |s|
  s.name         = 'RSKCollectionViewRetractableFirstItemLayout'
  s.version      = '3.0.0'
  s.summary      = 'A light-weight UICollectionViewFlowLayout subclass that allows the first item to be retractable.'
  s.homepage     = 'https://github.com/ruslanskorb/RSKCollectionViewRetractableFirstItemLayout'
  s.license      = { :type => 'Apache', :file => 'LICENSE' }
  s.authors      = { 'Ruslan Skorb' => 'ruslan.skorb@gmail.com' }
  s.source       = { :git => 'https://github.com/ruslanskorb/RSKCollectionViewRetractableFirstItemLayout.git', :tag => s.version.to_s }
  s.platform     = :ios, '12.0'
  s.swift_version = '5.0'
  s.source_files = 'RSKCollectionViewRetractableFirstItemLayout/*.{swift}'
  s.framework    = 'UIKit'
  s.requires_arc = true
end
