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
      container = ScriptingContainer.new(LocalContextScope::SINGLETHREAD)
      container.setCompatVersion(Ruby.getGlobalRuntime.getInstanceConfig.getCompatVersion)

      cmd_parts = []
      cmd_parts << "require 'rubygems'"
      cmd_parts << "require 'bundler/setup'" if bundler?
      cmd_parts << "require 'rspec'"
      cmd_parts << "RSpec::Core::Runner.run(arguments)"

      container.put('arguments', paths)
      success = container.runScriptlet(cmd_parts.join("\n"))
      success == 0
    end
  end

end
