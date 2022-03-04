# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::CurrentFile do
  subject(:current_file) { described_class.new(file_path) }

  let(:file_path) { "spec/fixtures/current_file.txt" }

  describe "#initialize" do
    it "sets the file path" do
      expect(current_file.path).to eq(file_path)
    end
  end
end
