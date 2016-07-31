## Guard::RSpec::JRuby
[![Build Status](https://travis-ci.org/garrettheaver/guard-rspec-jruby.svg?branch=master)](https://travis-ci.org/garrettheaver/guard-rspec-jruby)

We all love Guard::RSpec and it works wonders on MRI but exec'ing or system'ing with JRuby means spinning up a whole new JVM which takes far too long.

In short, this plugin replaces the Guard `run_via_shell` method and executes your specs in a JRuby `ScriptingContainer`. Even the setup on these can be too slow so we keep the container "warmed up" and ready to go after each run. The net result is that spec runs are virtually instant, just like on MRI.

Not all the optional parameters from Guard::RSpec are supported but this extension shouldn't balk at them either.

To use simply `require "guard-rspec-jruby"` and replace your `guard "rspec"` statement with `guard "rspec-jruby"`

Thanks to Joe Kutner (http://github.com/jkutner) for guard-jruby-rspec upon which some of this extension is based

