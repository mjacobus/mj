# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::Candidate do
  subject(:candidate) do
    described_class.new(
      path: "path.rb",
      type: "rspec"
    )
  end

  it "has a path" do
    expect(candidate.path).to eq("path.rb")
  end

  it "has a type" do
    expect(candidate.type).to eq("rspec")
  end

  describe "#exist?" do
    it "returns true if the file exists" do
      candidate = described_class.new(
        path: "spec/mj/alternative_file/candidate_spec.rb",
        type: "rspec"
      )

      expect(candidate).to exist
    end

    it "returns false if the file does not exist" do
      expect(candidate).not_to exist
    end
  end
end
