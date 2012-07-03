require 'java'
require 'guard'
require 'guard/guard'
require 'guard/rspec'

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

    def with_container
      warmup unless @container
      yield @container
      warmup
    end

    def warmup
      container = ScriptingContainer.new(LocalContextScope::SINGLETHREAD)
      container.setCompatVersion(Ruby.getGlobalRuntime.getInstanceConfig.getCompatVersion)

      script = ["require 'rubygems'"]
      script << "require 'bundler/setup'" if bundler?
      script << "require 'rspec'"
      container.runScriptlet(script.join("\n"))

      @container = container
    end

  end

end
