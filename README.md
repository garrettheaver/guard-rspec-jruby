## Guard::RSpec::JRuby

[![Build Status](https://travis-ci.org/garrettheaver/guard-rspec-jruby.png)](https://travis-ci.org/garrettheaver/guard-rspec-jruby)

This is nothing more than an extension on the regular Guard::RSpec we all love. This version however is designed not to run like a pig with lead boots on. I joke of course and Guard::RSpec works wonders on MRI but exec'ing or system'ing with JRuby means spinning up a whole new JVM which just isn't cricket when you're in a fast TDD loop.

So in short this plugin replaces the `run_via_shell` method and executes your specs in a JRuby `ScriptingContainer`. Even the setup on these can be too slow for my liking so we keep the container "warmed up" and ready to go after each run. The net result (works on my machine) is that spec runs are virtually instant, just like MRI.

Not all the optional parameters from Guard::RSpec are supported but this extension shouldn't balk at them either.

To use simply `require "guard-rspec-jruby"` and replace your `guard "rspec"` statement with `guard "rspec-jruby"`

Please direct any helpful suggestions my way and any complaints to /dev/null

Thanks to Joe Kutner (http://github.com/jkutner) for guard-jruby-rspec upon which some of this extensions ideas are based

