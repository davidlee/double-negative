require 'find'
require 'pathname'
require 'active_support/core_ext/module/delegation'

class DoubleNegative::SourceFileTree

  attr_reader :root_path

  SUPPORTED_EXTENSIONS = %w(jpeg jpg nef mov).freeze

  def initialize(dirname)
    @root_path = Pathname.new(dirname).realpath.to_s
  end

  def filepaths
    find do |path|
      FileTest.file?(path) && filetype_supported?(path)
    end
  end

  def find
    paths = []
    Find.find(root_path) do |path|
      Find.prune if File.basename(path)[0] == '.' # skip dotfiles / dirs
      if yield(path)
        paths << path
      end
    end
    paths
  end

  def filetype_supported?(path)
    SUPPORTED_EXTENSIONS.include?(File.extname(path).delete('.').downcase)
  end

  private

end
