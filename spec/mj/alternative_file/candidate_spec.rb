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

  it "implements ==" do
    equal_object = create_candidate("path.rb", "rspec")
    different_object = create_candidate("foo.rb", "bar")

    expect(candidate == equal_object).to be(true)
    expect(candidate == different_object).to be(false)
    expect([candidate]).to include(equal_object)
    expect([candidate]).not_to include(create_candidate("path.rb", "not_rspec"))
    expect([candidate]).not_to include(create_candidate("not_path.rb", "rspec"))
    expect(candidate).not_to eq(create_candidate("path.rb", "not_rspec"))
    expect(candidate).not_to eq(create_candidate("not_path.rb", "rspec"))
  end
end
