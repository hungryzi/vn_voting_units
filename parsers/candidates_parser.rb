class String
  def clean
    chomp("").strip.gsub(160.chr("UTF-8"), "")
  end
end

class CandidateRow
  def initialize(row)
    @row = row
  end

  def to_csv
    [name, dob, gender, address, ethnicity, religion, giao_duc_pho_thong, chuyen_mon_nghiep_vu, hoc_ham_hoc_vi,
      ly_luan_chinh_tri, position, employer, party_member_since, parliment_past_memberships, dai_bieu_hdnd]
  end

  def name
    @row.cells[1].text.clean
  end

  def dob
    @row.cells[2].text.clean
  end

  def gender
    @row.cells[3].text.clean
  end

  def address
    @row.cells[4].text.clean
  end

  def ethnicity
    @row.cells[5].text.clean
  end

  def religion
    @row.cells[6].text.clean
  end

  def giao_duc_pho_thong
    @row.cells[7].text.clean
  end

  def chuyen_mon_nghiep_vu
    @row.cells[8].text.clean
  end

  def hoc_ham_hoc_vi
    @row.cells[9].text.clean
  end

  def ly_luan_chinh_tri
    @row.cells[10].text.clean
  end

  def position
    @row.cells[11].text.clean
  end

  def employer
    @row.cells[12].text.clean
  end

  def party_member_since
    @row.cells[13].text.clean
  end

  def parliment_past_memberships
    @row.cells[14].text.clean
  end

  def dai_bieu_hdnd
    @row.cells[15].text.clean
  end
end

class CandidateTable
  def initialize(table)
    @table = table
  end

  def candidates_count
    @table.rows.length - 2
  end

  def candidate_rows
    @table.rows.slice(2, candidates_count).map do |r|
      CandidateRow.new r
    end
  end
end

require 'csv'
require 'docx'

candidates = []

unit_index = 0
candidates_doc = Docx::Document.open('./candidates.docx')

# candidates_doc.paragraphs.each do |p|
#   if p.text.include?("SỐ ĐƠN VỊ BẦU CỬ") || p.text.include?("Đơn vị bầu cử")
#     puts p.text
#   end
# end

CSV.foreach("./voting_units.csv") do |unit|
  unit_province = unit[0]
  unit_number = unit[1]

  table = CandidateTable.new candidates_doc.tables.last
  table.candidate_rows.each do |r|
    candidate_row = r.to_csv
    candidate_row.unshift(unit_province)
    candidate_row.unshift(unit_number)
    candidates << candidate_row
  end

  unit_index += 1

  puts "done #{unit_province} #{unit_number}"
end

CSV.open("./candidates.csv", "w") do |csv|
  candidates.each do |u|
    csv << u
  end
end
