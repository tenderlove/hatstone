$LDFLAGS = RbConfig::CONFIG["LDFLAGS"] = "-L."

require 'mkmf'

ldflags = cppflags = nil

begin
  brew_prefix = `brew --prefix hidapi`.chomp
  ldflags   = "#{brew_prefix}/lib"
  cppflags  = "#{brew_prefix}/include"
  pkg_conf  = "#{brew_prefix}/lib/pkgconfig"

  ENV["PKG_CONFIG_PATH"] = pkg_conf
rescue
end

pkg_config "capstone"
dir_config "capstone", cppflags, ldflags

raise "Install capstone!" unless have_header "capstone.h"
raise "Install capstone!" unless have_library "capstone"

create_makefile('hatstone')
