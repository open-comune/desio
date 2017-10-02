class Object
  def pat
    yield self
  end
end

module MD2CSV
  extend self

  def escape(item)
    if item.include?("\"")
      item.gsub("\"", "\"\"")
    else
      item
    end.pat do |s|
      "\"#{s}\""
    end
  end

  def convert_line(md_line)
    md_line.gsub(/(\ )?\|(\ )?/, ",")[1...-1].split(",").map do |item|
      escape(item)
    end.join(",")
  end

  def convert_md_lines(md_lines)
    ([
      convert_line(md_lines[0]),
    ] + md_lines[2..-1].map do |md_line|
      convert_line(md_line)
    end).join("\n")
  end

  def convert_file(filename)
    File.read(filename).lines.map(&:strip).pat do |md_lines|
      convert_md_lines(md_lines)
    end
  end
end

File.write("dataset.csv", MD2CSV.convert_file("table.md"))
