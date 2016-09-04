require 'active_support/core_ext/hash/keys'

class Pho::MergePlan

  attr_reader :source_tree, :dest_path, :nodes, :create_dirs

  def initialize(source_file_tree, dest, options={})
    @source_tree = source_file_tree
    @dest_path   = validate_destination_path(dest)
    @options     = defaults.merge(options.symbolize_keys)
    @create_dirs = []
  end

  def defaults
    {}
  end

  def build
    @nodes = source_tree.filepaths.map do |path|
      node = Pho::Filenode.new(source: path)
      node.creation_time = Pho::Metadata.new(path).creation_time
      node.destination = destination(node)
      node
    end
  end

  def check
    nodes.each do |node|
      # check for an existing file in destination path
      if File.exist?(node.destination)
        # TODO check File.identical?
        # ask / decide
        node.skip = true
      end
    end
  end

  def execute
    FileUtils.mkdir_p(dest_path) unless File.exists?(dest_path) # TODO make this an option
    nodes.each do |node|
      if should_process?(node)

        # ensure directory exists
        dir = File.dirname(node.destination)
        FileUtils.mkdir_p(dir, verbose: true) unless File.exists?(dir)

        # copy file
        # TODO allow other strategies e.g. mv; allow dep injection of FileUtils::DryRun
        FileUtils.cp node.source, node.destination, verbose: true
      end
    end
  end

  def should_process?(node)
    if node.force
      true
    elsif node.skip || File.exists?(node.destination)
      false
    else
      true
    end
  end

  private

  def validate_destination_path(path)
    raise ArgumentError.new(path) unless path.is_a?(String)
    raise ArgumentError.new(path) if File.exists?(path) unless File.directory?(path)

    if path[0] == '/'
      @path = path
    else
      @path = File.expand_path(path)
    end
  end

  # TODO make this support different strategies, e.g. preserving current relative path
  def destination(node)
    File.join(dest_path, *dest_subfolders(node), File.basename(node.source))
  end

  def dest_subfolders(node)
    node.creation_time.strftime('%Y/%m').split('/')
  end

end

