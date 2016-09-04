require 'find'
require 'pathname'
require 'active_support/core_ext/module/delegation'

class Pho::SourceFileTree

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

=begin
  def convert_relative(abs_path)
    path = File.realpath(abs_path)

    if path == root_path
      '.'
    else
      # TODO error handling
      path.partition(root_path).last.gsub(/^\//,'')
    end
  end

  def relative_filepaths
    filepaths.map {|x| convert_relative(x) }
  end

  def subfolders
    find do |path|
      path != root_path && FileTest.directory?(path)
    end
  end

  def relative_subfolders
    subfolders.map {|x| convert_relative(x) }
  end
=end

  private

end
