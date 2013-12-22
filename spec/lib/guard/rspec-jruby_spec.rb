require 'tmpdir'
require_relative '../../../lib/guard/rspec-jruby'

java_import java.io.StringWriter

module Guard
  describe RSpecJRubyRunner do

    let(:runner) { ::Guard::RSpecJRubyRunner.new }

    class SpecScriptingContainer < ScriptingContainer
      def initialize(*args)
        super
        setOutput(StringWriter.new)
        setError(StringWriter.new)
      end
    end

    before(:each) do
      verbose, $VERBOSE = $VERBOSE, nil
      Object.const_set("ScriptingContainer", SpecScriptingContainer)
      $VERBOSE =  verbose
    end

    it 'returns true from run_via_shell when the specs pass' do
      Dir.mktmpdir do |dir|
        path = File.join(dir, 'passing_spec.rb')

        File.open(path, 'w') do |f|
          f.write <<-EOF
            describe 'a passing spec' do
              it 'is true that true is true' do
                expect(true).to eq(true)
              end
            end
          EOF
        end

        expect(runner.run_via_shell([path], {})).to eq(true)
      end
    end

    it 'returns false from run_via_shell when the specs fail' do
      Dir.mktmpdir do |dir|
        path = File.join(dir, 'failing_spec.rb')

        File.open(path, 'w') do |f|
          f.write <<-EOF
            describe 'a failing spec' do
              it 'is false that false is true' do
                expect(false).to eq(true)
              end
            end
          EOF
        end

        expect(runner.run_via_shell([path], {})).to eq(false)
      end
    end

    it 'gracefully handles errors ocurring within the container' do
      Dir.mktmpdir do |dir|
        path = File.join(dir, 'failing_spec.rb')

        File.open(path, 'w') do |f|
          f.write <<-EOF
            describe 'a spec with a syntax error'
              it 'is desirable that the guard not crash when syntax errors occur' do
                expect(true).to not_matter
              end
            end
          EOF
        end

        expect(UI).to receive(:error).with(/SyntaxError/)
        expect(runner.run_via_shell([path], {})).to eq(false)
      end
    end

  end
end
