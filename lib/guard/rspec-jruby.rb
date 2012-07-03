require 'java'
require 'guard'
require 'guard/guard'
require 'guard/rspec'
require 'thread'

import org.jruby.Ruby
import org.jruby.embed.ScriptingContainer
import org.jruby.embed.LocalContextScope

module Guard

  class RSpecJRuby < ::Guard::RSpec
    def initialize(watchers = [], options = {})
      super
      @runner = RSpecJRubyRunner.new(options)
    end
  end

  class RSpecJRubyRunner < ::Guard::RSpec::Runner

    def run_via_shell(paths, options)
      with_container do |container|
        container.put('arguments', paths)
        container.runScriptlet("RSpec::Core::Runner.run(arguments)") == 0
      end
    end

    private

    POOL_SIZE = 5

    def with_container
      container = pool.shift || make

      begin
        yield container
      ensure
        container.terminate
      end

      replenish!
    end

    def pool
      @pool ||= []
    end

    def replenish!
      Thread.new(POOL_SIZE - pool.count) { |n| n.times{ pool << make } }
    end

    def make
      container = ScriptingContainer.new(LocalContextScope::SINGLETHREAD)
      container.setCompatVersion(Ruby.getGlobalRuntime.getInstanceConfig.getCompatVersion)

      script = ["require 'rubygems'"]
      script << "require 'bundler/setup'" if bundler?
      script << "require 'rspec'"
      container.runScriptlet(script.join("\n"))

      container
    end

  end

end
