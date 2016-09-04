require 'active_support/core_ext/hash/keys'

class Pho::Merge

  attr_reader :source_tree, :dest_folder, :plan, :options

  def initialize(src, dest, options={})
    @options     = defaults.merge(options.symbolize_keys)

    @source_tree = Pho::SourceFileTree.new(src)
    @plan        = Pho::MergePlan.new(source_tree, dest)
  end

  def defaults
    {}
  end

end
