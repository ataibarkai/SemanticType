Pod::Spec.new do |s|

  s.name         = "TypeBurritoFramework"
  s.version      = "1.1.3"
  s.summary      = "Over-Typing Swift μFramework"

  s.description  = "TypeBurritoFramework allows one to simply create (effective) subtypes for Swift structs (which cannot be subclassed).\nThis allows for a type model which better reflects the programmer's mental model.\ne.g. distinguishing between String -> SQLQuery, Double -> Kgs, etc."

  s.homepage     = "https://github.com/ataibarkai/TypeBurritoFramework"
  s.license      = "MIT"
  s.author             = { "Atai Barkai" => "atai.barkai@gmail.com" }
  s.social_media_url   = "http://twitter.com/ataiiam"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.11"

  s.source       = { :git => "https://github.com/ataibarkai/TypeBurritoFramework.git", :tag => "v1.1.3" }

  s.source_files  = "CommonSource", "CommonSource/**/*.{h,m}"
end
