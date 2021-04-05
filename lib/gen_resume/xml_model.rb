module GenResume
  require 'rexml/document'

  # In-memory model of the given XML file
  class XmlModel
    attr_accessor :character_converter, :document

    def initialize(xml_path, character_converter)
      self.document = REXML::Document.new(File.new(xml_path))
      self.character_converter = character_converter
    end

    def resume
      @resume ||=
        Node.new(
          document.root,
          character_converter: character_converter
        )
    end
  end
end
