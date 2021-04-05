module GenResume
  class CommandLine
    require 'slop'

    attr_accessor :options

    def initialize
      self.options = Slop.parse(&args)
      return if options.help?

      check_options
      check_erb_file
      check_xml_args
      check_xml_file
    end

    def print_help
      puts options
    end

    def help?
      options.help?
    end

    def erb_path
      options[:html] || options[:latex]
    end

    def xml_path
      options.arguments.first
    end

    def mode
      options[:html] ? :html : :latex
    end

    private

    def args
      proc do |o|
        o.banner = help_banner
        o.string('--latex', 'erb for latex')
        o.string('--html', 'erb for latex')
        o.bool('-h', '--help', 'print help message')
      end
    end

    def help_banner
      [
        'Usage: genresume --latex=LATEX.ERB RESUME.XML',
        '   or: genresume --html=HTML.ERB RESUME.XML',
        '',
        'Options:'
      ].join("\n")
    end

    def check_options
      html, latex = options.to_h.values_at(:html, :latex)

      raise '--html and --latex are mutually exclusive' if html && latex
      raise 'one of --html or --latex is required' if !html && !latex
    end

    def check_erb_file
      raise '.erb template expected' unless erb_path.downcase.end_with?('.erb')
      raise "'#{erb_path}' is not readable" unless File.readable?(erb_path)
    end

    def check_xml_args
      args = options.arguments

      raise 'XML file not specified' if args.empty?
      raise format('too many arguments: %s', args) if args.length != 1
    end

    def check_xml_file
      raise "#{xml_path} not .xml file" unless /\.[Xx][Mm][Ll]$/ =~ xml_path
      raise "#{xml_path} is not readable" unless File.readable?(xml_path)
    end
  end
end
