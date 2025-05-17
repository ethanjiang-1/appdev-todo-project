ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup"        # Set up gems listed in the Gemfile.
# require "bootsnap/setup"     # ← comment out to avoid the aarch64 segfault
