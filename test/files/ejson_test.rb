require_relative '../test_helper'
require_local 'files/ejson'

module Files
  describe Ejson do
    attr_reader :filepath, :subject, :object
    before do
      @filepath = "#{TMP_DIR}/test.ejson"
      @subject = Ejson.new(@filepath)
      @object = { a: 1, 'b' => '2' }
    end
    after { File.delete(filepath) if File.exist?(filepath) }

    describe '#write' do
      it '(over)writes object to file and encrypts with ejson' do
        Json.any_instance.expects(:write).with(object)
        Runners::Shell.expects(:run).with("ejson encrypt #{filepath}")
        assert_equal object, subject.write(object)
      end
    end

    describe '#read' do
      it 'returns object from decrypted ejson file' do
        Runners::Shell.expects(:run).with("ejson decrypt #{filepath}").returns(object.to_json)
        expected = object.each_with_object({}) { |(k, v), h| h[k.to_s] = v }

        refute_equal object, expected, 'Symbols are converted to strings coming from json'
        assert_equal expected, subject.read
      end

      it 'raises error if ejson file does not exist' do
        refute File.exist?(filepath)
        assert_raises(Runners::ShellError) { subject.read }
      end

      it 'does not raise if not_found_result is provided' do
        refute File.exist?(filepath)
        expected = {}
        assert_equal expected, subject.read(expected)
      end
    end
  end
end
