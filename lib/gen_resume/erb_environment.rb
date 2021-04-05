module GenResume
  require 'erb'

  # Renders a given .erb file using the given +Resume+ as its context.
  class ErbEnvironment
    attr_accessor :erb, :resume

    def initialize(erb_path, resume)
      self.erb = ERB.new(File.read(erb_path), nil, '<>')
      self.resume = resume
    end

    def render
      erb.result(binding)
    end
  end
end
