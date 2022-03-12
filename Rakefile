def each_node node, &block
  yield node
  node["inner"]&.each { |n| each_node(n, &block) }
end

def find_comment node
end

def find_enums tree, &block
  if tree["kind"] == "EnumDecl"
    name = tree["name"]
    return if tree["loc"]["includedFrom"]

    each_node(tree) { |n|
      if n["kind"] == "EnumConstantDecl"
        block.call n["name"]
      end
    }
  else
    tree["inner"]&.each { |node| find_enums node, &block }
  end
end

ENUMS = "ext/hatstone/hatstone_enums.inc"

file ENUMS do
  require "json"

  ENV["PKG_CONFIG_PATH"] = `brew --prefix`.chomp + "/lib/pkgconfig"
  header = `pkg-config --cflags-only-I capstone`.chomp.sub(/^-I/, '') + "/capstone.h"
  ast = JSON.parse `clang -Xclang -ast-dump=json -fsyntax-only #{header}`.chomp
  File.open(ENUMS, "w") do |f|
    find_enums ast do |enum|
      f.puts "rb_define_const(klass, \"#{enum.sub(/^CS_/, '')}\", INT2NUM(#{enum}));"
    end
  end
end

task :gen_enums => ENUMS

require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test/lib" << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
  t.warning = true
end

require 'rake/extensiontask'
Rake::ExtensionTask.new("hatstone")

task :compile => :gen_enums
task :test => :compile
