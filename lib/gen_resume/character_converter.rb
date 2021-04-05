module GenResume
  class << self
    attr_accessor :character_converters
  end

  # Converts special characters between their XML representation and
  # another repesentation.
  class CharacterConverter
    attr_accessor :map

    def initialize(map)
      self.map = map
    end

    def sub(str)
      str.dup.tap do |copy|
        map.each { |src, dest| copy.gsub!(src, dest) }
      end
    end
  end

  self.character_converters = {
    # XML -> LaTeX
    latex: CharacterConverter.new(
      # "\n"        => " %\n",
      '&endash;' => '--',
      '&emdash;' => '---',
      '&latex;'  => '\\\LaTeX',
      '&amp;'    => '\\\&'
    ),
    # XML -> html
    html: CharacterConverter.new(
      # /\s*\n\s*/m => ' ',
      '&endash;' => '&ndash;',
      '&emdash;' => '&mdash;',
      '&latex;'  => 'LaTeX',
      '&amp;'    => '&amp;',
      '-'        => '<wbr>-'
    )
  }
end
