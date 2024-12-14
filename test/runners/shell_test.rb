require_relative '../test_helper'
require_local 'runners/shell'

module Runners
  describe Shell do
    describe '.run' do
      it 'returns the response string from the shell command' do
        assert_equal 'foobar', Shell.run("echo 'foobar'")
        assert_equal "foo\nbar", Shell.run("echo 'foo\nbar'")
      end

      it 'raises error if the exit code is different from zero' do
        error = assert_raises(ShellError) { Shell.run('cat foobar_file') }

        msg = "Command failed with exit code 1. Error details: "\
          "`cat: foobar_file: No such file or directory`"
        assert_equal msg, error.message
      end
    end

    describe '.run_and_parse' do
      it 'returns an array in which each shell line is an item inside the array' do
        expected = ['line1', 'line2']
        assert_equal expected, Shell.run_and_parse("echo 'line1\nline2'")
      end

      it 'parses results according to a given named regular expression' do
        expected = [{ 'num' => '1' }, { 'num' => '2' }]
        assert_equal expected, Shell.run_and_parse(
          "echo 'line1\nline2'",
          named_regex: /line(?<num>\d+)/
        )
      end

      it 'converts parsed results according to a given lambda' do
        expected = [{ 'num' => 100 }, { 'num' => 200 }]
        assert_equal expected, Shell.run_and_parse(
          "echo 'line1\nline2'",
          named_regex: /line(?<num>\d+)/,
          converters: { num: ->(n) { n.to_i * 100 } }
        )
      end
    end
  end
end
