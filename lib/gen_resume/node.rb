module GenResume
  # A single XML element in the input XML file
  class Node
    attr_accessor :node, :options

    def initialize(node, options)
      self.node = node
      self.options = options.dup
    end

    def to_s
      @to_s ||=
        begin
          if element_name == :text
            options[:character_converter].sub(node.to_s)
          elsif element_name == :comment
            ''
          else
            inline(self)
          end
        end
    end

    def strip
      to_s.strip
    end

    def element_name
      case node.node_type
      when :text then :text
      when :comment then :comment
      else
        node.name.to_sym
      end
    end

    def [](attribute)
      val = node.attributes[attribute.to_s]
      val.gsub!(' ', '%20') if val && attribute.to_s == 'href'
      val
    end

    def children
      node.children.map { |child| self.class.new(child, options) }
    end

    def inline(node = nil, &callback)
      options[:inline] = callback if callback
      if node
        options[:inline].call(node)
      else
        options[:inline]
      end
    end

    def respond_to_missing?(name, _include_all)
      /([^_]+)_children/ =~ name || super
    end

    def method_missing(name, *args)
      if (match = /([^_]+)_children/.match(name))
        children_named(match[1], args)
      else
        child_node(name) || super
      end
    end

    private

    def children_named(name, args)
      selector = (args.first&.is_a?(Hash) ? args.first : {})

      xpath = node.elements.to_a("./#{name}#{attributes_selector(selector)}")

      xpath.map { |node| self.class.new(node, options) }
    end

    def attributes_selector(selector)
      return '' if selector.empty?

      "[#{selector.map { |key, val| "@#{key}='#{val}'" }.join(' and ')}]"
    end

    def child_node(name)
      child = node.elements[name.to_s]
      self.class.new(child, options) if child
    end
  end
end
