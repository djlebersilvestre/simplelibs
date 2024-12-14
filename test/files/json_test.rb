require_relative '../test_helper'
require_local 'files/json'

module Files
  describe Json do
    attr_reader :filepath, :subject, :object
    before do
      @filepath = "#{TMP_DIR}/test.json"
      @subject = Json.new(@filepath)
      @object = { a: 1, 'b' => '2' }
    end
    after { File.delete(filepath) if File.exist?(filepath) }

    describe '#write' do
      it '(over)writes object with pretty format to json file' do
        expected = JSON.pretty_generate(object)
        assert_equal object, subject.write(object)
        assert_equal expected, File.read(filepath)

        object['a'] = 123
        expected = JSON.pretty_generate(object)
        assert_equal object, subject.write(object)
        assert_equal expected, File.read(filepath)
      end
    end

    describe '#read' do
      it 'returns object from json file' do
        File.write(filepath, object.to_json)

        expected = object.each_with_object({}) { |(k, v), h| h[k.to_s] = v }
        refute_equal object, expected, 'Symbols are converted to strings coming from json'
        assert_equal expected, subject.read
      end

      it 'raises error if json file does not exist' do
        refute File.exist?(filepath)
        error = assert_raises(Errno::ENOENT) { subject.read }
        assert_match(/No such file or directory/, error.message)
      end

      it 'does not raise if not_found_result is provided' do
        refute File.exist?(filepath)
        expected = {}
        assert_equal expected, subject.read(expected)
      end

      it 'returns not_found_result if json file is empty' do
        File.write(filepath, '')
        expected = []
        assert_equal expected, subject.read(expected)
      end
    end
  end
end

