## Guard::RSpec::JRuby

This is nothing more than an extension on the regular Guard::RSpec we all love. This version however is designed not to run like a pig with lead boots on. I joke of course and Guard::RSpec works wonders on MRI but exec'ing or system'ing with JRuby means spinning up a whole new JVM which just isn't cricket when you've in a fast TDD loop.


So in short this plugin replaces the `run_via_shell` method and executes your specs in a JRuby `ScriptingContainer`. Even these can be too slow for my liking so we keeps a pool of "warmed up" and ready to go. The net result (works on my machine) is that spec runs are virtually instant, just like MRI.

Not all the optional parameters from Guard::RSpec are support but this extension shouldn't balk at them either. We also add one param (:pool_size) which allows you to configure how many `ScriptingContainers` to keep "warm".

To use simply `require "guard-rspec-jruby"` and replace your `guard "rspec"` statement with `guard "rspec-jruby"`

Please direct any helpful suggestions my way and any complaints to /dev/null

Thanks to Joe Kutner (http://github.com/jkutner) for guard-jruby-rspec upon which some of this extensions ideas are based

--
G
