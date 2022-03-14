# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::Candidate do
  subject(:candidate) do
    described_class.new(
      path: "path.rb",
      type: "spec",
      metadata: {
        "foo" => "bar",
        "baz" => "qux"
      }
    )
  end

  it "has a path" do
    expect(candidate.path).to eq("path.rb")
  end

  it "has a type" do
    expect(candidate.type).to eq("spec")
  end

  describe "#exist?" do
    it "returns true if the file exists" do
      candidate = described_class.new(
        path: "spec/mj/alternative_file/candidate_spec.rb",
        type: "spec"
      )

      expect(candidate).to exist
    end

    it "returns false if the file does not exist" do
      expect(candidate).not_to exist
    end
  end

  it "implements ==" do
    equal_object = create_candidate("path.rb", "spec")
    different_object = create_candidate("foo.rb", "bar")

    expect(candidate == equal_object).to be(true)
    expect(candidate == different_object).to be(false)
    expect([candidate]).to include(equal_object)
    expect([candidate]).not_to include(create_candidate("path.rb", "not_spec"))
    expect([candidate]).not_to include(create_candidate("not_path.rb", "spec"))
    expect(candidate).not_to eq(create_candidate("path.rb", "not_spec"))
    expect(candidate).not_to eq(create_candidate("not_path.rb", "spec"))
  end

  describe "#to_s" do
    it "returns path when debug is off" do
      expect(candidate.to_s).to eq("path.rb")
    end

    it "includes metadata when debug is true" do
      expect(candidate.to_s(debug: true)).to eq("path.rb(type:spec,exists:false,baz:qux,foo:bar)")
    end
  end
end
