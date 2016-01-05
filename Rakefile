require "fileutils"

MRUBY_VERSION = "1.2.0"
APP_NAME = ENV["APP_NAME"] || "grokly"
APP_ROOT = ENV["APP_ROOT"] || Dir.pwd
MRUBY_ROOT = File.expand_path(ENV["MRUBY_ROOT"] || "#{APP_ROOT}/mruby")
MRUBY_CONFIG = File.expand_path(ENV["MRUBY_CONFIG"] || "build_config.rb")

ENV["MRUBY_ROOT"] = MRUBY_ROOT
ENV["MRUBY_CONFIG"] = MRUBY_CONFIG

file :mruby do
  sh "curl -L --fail --retry 3 --retry-delay 1 https://github.com/mruby/mruby/archive/1.2.0.tar.gz -s -o - | tar zxf -"
  FileUtils.mv("mruby-1.2.0", "mruby")
end

Rake::Task[:mruby].invoke unless Dir.exist?(MRUBY_ROOT)
Dir.chdir(MRUBY_ROOT)
load "#{MRUBY_ROOT}/Rakefile"

desc "Compile binary"
task compile: [:all] do
  %W(#{MRUBY_ROOT}/build/x86_64-pc-linux-gnu/bin/#{APP_NAME} #{MRUBY_ROOT}/build/i686-pc-linux-gnu/#{APP_NAME}").each do |bin|
    sh "strip --strip-unneeded #{bin}" if File.exist?(bin)
  end

  require_relative "mrblib/grokly/version"

  bin_path = APP_ROOT + "/bin"
  FileUtils.mkdir(bin_path) unless Dir.exists?(bin_path)

  puts "Writing #{bin_path}/#{APP_NAME} - v#{Grokly::VERSION}"
  FileUtils.cp("#{MRUBY_ROOT}/build/host/bin/#{APP_NAME}", bin_path)
end

desc "generate a release tarball"
task release: :compile do
  require "tmpdir"
  require_relative "mrblib/grokly/version"

  # since we're in the mruby/
  release_dir  = "releases/v#{Grokly::VERSION}"
  release_path = Dir.pwd + "/../#{release_dir}"
  app_name     = "grokly-#{Grokly::VERSION}"
  FileUtils.mkdir_p(release_path)

  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      MRuby.each_target do |_|
        next if name == "host"

        # TODO : Copy binaries in bin/releases/v0.0.x/host/grokly
        arch = name
        bin  = "#{build_dir}/bin/#{exefile(APP_NAME)}"
        FileUtils.mkdir_p(name)
        FileUtils.cp(bin, name)

        Dir.chdir(arch) do
          arch_release = "#{app_name}-#{arch}"
          puts "Writing #{release_dir}/#{arch_release}.tgz"
          `tar czf #{release_path}/#{arch_release}.tgz *`
        end
      end

      puts "Writing #{release_dir}/#{app_name}.tgz"
      `tar czf #{release_path}/#{app_name}.tgz *`
    end
  end
end

namespace :test do
  desc "run mruby & unit tests"
  # only build mtest for host
  task mtest: :compile do
    # in order to get mruby/test/t/synatx.rb __FILE__ to pass,
    # we need to make sure the tests are built relative from MRUBY_ROOT
    MRuby.each_target do |target|
      # only run unit tests here
      target.enable_bintest = false
      run_test if target.test_enabled?
    end
  end

  def clean_env(envs)
    old_env = {}
    envs.each do |key|
      old_env[key] = ENV[key]
      ENV[key] = nil
    end
    yield
    envs.each do |key|
      ENV[key] = old_env[key]
    end
  end

  desc "run integration tests"
  task bintest: :compile do
    MRuby.each_target do |target|
      clean_env(%w(MRUBY_ROOT MRUBY_CONFIG)) do
        run_bintest if target.bintest_enabled?
      end
    end
  end
end

desc "run all tests"
Rake::Task["test"].clear
task test: ["test:mtest", "test:bintest"]

desc "cleanup"
task :clean do
  sh "rake deep_clean"
end
