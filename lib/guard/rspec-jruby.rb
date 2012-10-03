require 'java'
require 'guard'
require 'guard/guard'
require 'guard/rspec'
require 'thread'

java_import org.jruby.Ruby
java_import org.jruby.embed.ScriptingContainer
java_import org.jruby.embed.LocalContextScope

module Guard

  class RSpecJRuby < ::Guard::RSpec
    def initialize(watchers = [], options = {})
      super
      @runner = RSpecJRubyRunner.new(options)
    end
  end

  class RSpecJRubyRunner < ::Guard::RSpec::Runner

    def run_via_shell(paths, options)
      success = 1

      with_container do |ct|
        ct.put('arguments', paths)
        success = ct.runScriptlet("RSpec::Core::Runner.run(arguments)")
      end

      success == 0
    end

    private

    def with_container
      begin
        yield @container ||= make
      rescue Exception => e
        UI.error(e.message)
      ensure
        reset!(@container)
      end
    end

    def make
      container = ScriptingContainer.new(LocalContextScope::SINGLETHREAD)
      container.setCompatVersion(Ruby.getGlobalRuntime.getInstanceConfig.getCompatVersion)
      warmup(container)
      container
    end

    def warmup(container)
      script = ["require 'rubygems'"]
      script << "require 'bundler/setup'" if bundler?
      script << "require 'rspec'"
      container.runScriptlet(script.join("\n"))
    end

    def reset!(container)
      container.terminate
      warmup(container)
    end

  end

end
