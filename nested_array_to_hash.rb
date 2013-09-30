roster = [["Number", "Name", "Position", "Points per Game"],
          ["12","Joe Schmo","Center",[14, 32, 7, 0, 23] ],
          ["9", "Ms. Buckets ", "Point Guard", [19, 0, 11, 22, 0] ],
          ["31", "Harvey Kay", "Shooting Guard", [0, 30, 16, 0, 25] ], 
          ["7", "Sally Talls", "Power Forward", [18, 29, 26, 31, 19] ], 
          ["22", "MK DiBoux", "Small Forward", [11, 0, 23, 17, 0] ]]

def convert_roster_format(roster)
  headers = roster.shift

  hashed_rosters = []
  roster.each do |table_row|

    hashed_table_row = []
    table_row_headers = headers.dup
    until table_row_headers.empty?
      hashed_table_row << table_row_headers.shift
      hashed_table_row << prepare_cell(table_row.shift)
    end

    hashed_rosters << hashed_table_row

  end

  return hashed_rosters.map { |row| Hash[*row] }

end

def prepare_cell(cell)
  case cell
  when /^\d+$/
    cell.to_i
  else
    cell
  end
end

hashed_rosters = convert_roster_format(roster)

# I want an array of hashes
p hashed_rosters[2] == { "Number" => 31, "Name" => "Harvey Kay", "Position" => "Shooting Guard", "Points per Game" => [0, 30, 16, 0, 25] }
p hashed_rosters[0]["Name"] == "Joe Schmo"
