require 'minitest/autorun'
require_relative 'deep_dive'

class DeepDiveTest < Minitest::Test
  TEST_DIRECTORY = [
    'root/',
    [
      ['docs/', ['address_book.xlsx']],
      [
        'photos/',
        [
          ['january/', ['001.jpg', '002.jpg']],
          ['february/', []],
          ['march/', ['003.jpg']],
        ],
      ],
    ],
  ]

  describe "#file?" do
    it "recognizes a file properly" do
      assert_equal true, DeepDive.file?('test.txt')
      assert_equal true, DeepDive.file?(TEST_DIRECTORY[1][0][1][0])
    end

    it "recognizes a directory properly" do
      assert_equal false, DeepDive.file?(['the good files/', []])
      assert_equal false, DeepDive.file?(TEST_DIRECTORY)
    end
  end

  describe "#directory?" do
    it "recognizes a file properly" do
      assert_equal false, DeepDive.directory?('test.txt')
      assert_equal false, DeepDive.directory?(TEST_DIRECTORY[1][0][1][1])
    end

    it "recognizes a directory properly" do
      assert_equal true, DeepDive.directory?(['the good files/', []])
      assert_equal true, DeepDive.directory?(TEST_DIRECTORY)
    end
  end

  describe "#run" do
    it "shows no files for an empty directory" do
      assert_equal [], DeepDive.new(['empty/', []]).run()
    end

    it "shows no files for an empty directory" do
      input = ['empty/', ['1.txt', '2.txt']]
      result = DeepDive.new(input).run
      expected = input[1]

      expected.each do |file_name|
        assert_equal true, result.include?(file_name)
      end
      assert_equal expected.size, result.size
    end

    it "can get files from any depth" do
      input = ['a/', [['b/', [['c/', ['only_file.csv']]]]]]
      result = DeepDive.new(input).run
      expected = ['only_file.csv']

      assert_equal expected, result
    end

    it "works for an extended use case" do
      result = DeepDive.new(TEST_DIRECTORY).run
      expected = [
        'address_book.xlsx',
        '001.jpg',
        '002.jpg',
        '003.jpg',
      ]

      expected.each do |file_name|
        assert_equal true, result.include?(file_name)
      end
      result.each do |file_name|
        assert_equal true, expected.include?(file_name)
      end
    end
  end
end
