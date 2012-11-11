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
        puts "========= time to reset container =================="
        @container = reset!(@container)
        # reset!(@container)
      end
    end

    def make
      container = ScriptingContainer.new(LocalContextScope::SINGLETHREAD)
      container.setCompatVersion(Ruby.getGlobalRuntime.getInstanceConfig.getCompatVersion)
      container.setLoadPaths(Ruby.getGlobalRuntime.getGlobalVariables.get('$LOAD_PATH'))
      warmup(container)
      container
    end

    def warmup(container)
      script = ["require 'rubygems'"]
      script << "require 'bundler/setup'" if bundler?
      script << "require 'rspec'"
      puts "========= warmup#runScriptlet start =================="
      container.runScriptlet(script.join("\n"))
      puts "========= warmup#runScriptlet end =================="
    end

    def reset!(container)
      container.terminate
      puts "========= time to warmup container again =================="
      # warmup(container)
      make
    end

  end

end
