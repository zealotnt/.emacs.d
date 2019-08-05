require 'yaml'
require 'json'

def main
  parsed_elems = []
  YAML.parse_stream(ARGF) do |document|
    parsed =
      begin
        parse(document.children.first) || {}
      rescue => e
        STDERR.puts e.message
        {}
      end
    parsed_elems << parsed
  end

  parsed = {}
  if parsed_elems.length ==  1
    parsed = parsed_elems.first
    parsed = Hash[parsed.map {|k, v| ["#{k}:#{v}", v]}]
  else
    index = 1
    parsed_elems.each do |elem|
      value = Hash[elem.map {|k, v| ["#{index}_#{k}", v]}]
      parsed.merge!(value)
      index += 1
    end
  end

  puts JSON.pretty_generate(parsed)
end

def parse(node, current_path = nil)
  case node
  when Psych::Nodes::Scalar, Psych::Nodes::Alias
    { current_path => node.start_line }
  when Psych::Nodes::Mapping
    initial =
      if current_path
        { current_path => node.start_line }
      else
        {}
      end

    node.children.each_slice(2).reduce(initial) { |hash, (ykey, yvalue)|
      key =
        case ykey
        when Psych::Nodes::Scalar
          case o = ykey.value
          when Symbol
            ":#{o}"
          else
            o.to_s
          end
        else
          next hash
        end

      if value = parse(yvalue, "#{current_path}#{'.' if current_path}#{key}")
        hash.merge(value)
      else
        hash
      end
    }
  when Psych::Nodes::Sequence
    initial =
      if current_path
        { current_path => node.start_line }
      else
        {}
      end

    node.children.each_with_index.reduce(initial) { |hash, (yvalue, i)|
      if value = parse(yvalue, "#{current_path}[#{i}]")
        hash.merge(value)
      else
        hash
      end
    }
  end
end

main
