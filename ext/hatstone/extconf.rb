$LDFLAGS = RbConfig::CONFIG["LDFLAGS"] = "-L."

require 'mkmf'

ldflags = cppflags = nil

if RUBY_PLATFORM =~ /darwin/
  # macOS specific configuration using Homebrew
  begin
    brew_prefix = `brew --prefix hidapi`.chomp
    ldflags   = "#{brew_prefix}/lib"
    cppflags  = "#{brew_prefix}/include"
    pkg_conf  = "#{brew_prefix}/lib/pkgconfig"

    ENV["PKG_CONFIG_PATH"] = pkg_conf
  rescue
  end
else
  # Linux systems typically use pkg-config
  [
    "/usr/lib/pkgconfig",
    "/usr/local/lib/pkgconfig",
    "/usr/lib/`uname -m`-linux-gnu/pkgconfig"
  ].each do |path|
    if File.directory?(path)
      ENV["PKG_CONFIG_PATH"] = [ENV["PKG_CONFIG_PATH"], path].compact.join(":")
    end
  end
end

# Try to find capstone using pkg-config first
unless pkg_config("capstone")
  # Fallback to manual configuration
  dir_config("capstone", cppflags, ldflags)
end

raise "Install capstone!" unless have_header "capstone.h"
raise "Install capstone!" unless have_library "capstone"

create_makefile('hatstone')
