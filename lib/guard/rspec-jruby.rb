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

    def initialize(options = {})
      options = {
        :pool_size => 5
      }.merge(options)
      super(options)
    end

    def run_via_shell(paths, options)
      success = 1

      with_container do |container|
        container.put('arguments', paths)
        success = container.runScriptlet("RSpec::Core::Runner.run(arguments)")
      end

      success == 0
    end

    private

    def with_container
      container = pool.shift || make

      begin
        yield container
      rescue Exception => e
        UI.error(e.message)
      ensure
        container.terminate
      end

      replenish!
    end

    def pool
      @pool ||= []
    end

    def replenish!
      Thread.new(@options[:pool_size] - pool.count) { |n| n.times{ pool << make } }
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
