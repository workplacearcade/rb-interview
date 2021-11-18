require 'minitest/autorun'
require_relative 'deep_dive'

class DeepDiveTest < Minitest::Test
  TEST_DIRECTORY = {
    name: 'root/',
    contents: [
      {
        name: 'docs/',
        contents: ['address_book.xlsx']
      },
      {
        name: 'photos/',
        contents: [
          {
            name: 'january/',
            contents: ['001.jpg', '002.jpg']
          },
          {
            name: 'february/',
            contents: []
          },
          {
            name: 'march/',
            contents: ['003.jpg']
          }
        ]
      }
    ]
  }

  describe "#file?" do
    it "recognizes a file properly" do
      assert_equal true, DeepDive.file?('test.txt')
    end

    it "recognizes a directory properly" do
      assert_equal false, DeepDive.file?({name: 'the good files/', contents: []})
    end
  end

  describe "#directory?" do
    it "recognizes a file properly" do
      assert_equal false, DeepDive.directory?('test.txt')
    end

    it "recognizes a directory properly" do
      assert_equal true, DeepDive.directory?({name: 'the good files/', contents: []})
    end
  end

  describe "#run" do
    it "shows no files for an empty directory" do
      input = {name: 'empty/', contents: []}

      assert_equal [], DeepDive.new(input).run()
    end

    it "can get files from a shallow depth" do
      input = {
        name: 'not_empty/',
        contents: ['1.txt', '2.txt'],
      }
      result = DeepDive.new(input).run
      expected = ['1.txt', '2.txt']

      assert_equal [], result - expected
      assert_equal [], expected - result
      assert_equal expected.size, result.size
    end

    it "can get files from any depth" do
      input = {
        name: 'a/',
        contents: [
          {
            name: 'b/',
            contents: [
              {
                name: 'c/',
                contents: ['only_file.csv']
              }
            ]
          }
        ]
      }
      result = DeepDive.new(input).run
      expected = ['only_file.csv']

      assert_equal [], result - expected
      assert_equal [], expected - result
      assert_equal expected.size, result.size
    end

    it "works for an extended use case" do
      result = DeepDive.new(TEST_DIRECTORY).run
      expected = [
        'address_book.xlsx',
        '001.jpg',
        '002.jpg',
        '003.jpg',
      ]

      assert_equal [], result - expected
      assert_equal [], expected - result
      assert_equal expected.size, result.size
    end
  end
end
