=begin
This is a helper to generate excel sheets and parse excel sheets
=end

class Icing < Sinatra::Base


  def generate_xl_template(inventory_id)
    workbook = RubyXL::Workbook.new
    inventory = Inventories.where(:inventory_id => nil).where(:id => inventory_id).first

    worksheet = workbook[0]
    entries = inventory.entries

    cursor = 0
    entries["fields"].each do |row, type|
      worksheet.add_cell(0, cursor, row)
      worksheet.change_row_bold(0, true)
      cursor += 1
    end
    worksheet.add_cell(1,0, "Add data here...")

    workbook.stream
  end

  def parse_xl_template(data, inventory_id)
    workbook = RubyXL::Parser.parse_buffer(data)
    inventory = Inventories.where(:inventory_id => nil).where(:id => inventory_id).first

    worksheet = workbook[0]

    row_index = 0
    import = []
    keys = inventory.entries["fields"].keys
    worksheet.each do |row|
      if row_index == 0
        row_index += 1
        next
      end
      keyindex = 0
      timport = {}
      keys.each do |key|
        timport[key] =  row.cells[keyindex].value
        keyindex += 1
      end
      import << timport
    end

    import.each do |entry|
      inventory.add_row(:entries => entry.to_json)
    end

    import


  end


end
