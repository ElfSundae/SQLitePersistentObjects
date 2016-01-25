Pod::Spec.new do |s|
  s.name              = "SQLitePersistentObjects"
  s.version           = "1.1.0"
  s.license           = "MIT"
  s.summary           = "Persistent Objects for Cocoa & Cocoa Touch that using SQLite."
  s.homepage          = "https://github.com/ElfSundae/SQLitePersistentObjects"
  s.authors           = { "Elf Sundae" => "http://0x123.com" }
  s.source            = { :git => "https://github.com/ElfSundae/SQLitePersistentObjects.git", :tag => s.version, :submodules => true }
  s.social_media_url  = "https://twitter.com/ElfSundae"

  s.platform              = :ios
  s.ios.deployment_target = "6.0"
  s.requires_arc          = true
  s.source_files          = "SQLitePersistentObjects/SQLitePersistentObjects/**/*.{h,m}"
  s.libraries             = "sqlite3"
end
