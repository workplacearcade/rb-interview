class DeepDive
  attr_accessor :directory

  def initialize(directory)
    @directory = directory
  end

  def run
    []
  end

  private

  def self.file?(node)
    node.is_a? String
  end

  def self.directory?(node)
    node.is_a? Array
  end
end
