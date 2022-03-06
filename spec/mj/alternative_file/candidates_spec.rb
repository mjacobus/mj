# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::Candidates do
  subject(:candidates) { described_class.new(files) }

  let(:files) do
    [
      Mj::AlternativeFile::Candidate.new(
        path: "spec/mj/alternative_file/candidates_spec.rb",
        type: "spec"
      ),
      Mj::AlternativeFile::Candidate.new(
        path: "foo_controller.rb",
        type: "controller"
      )
    ]
  end

  it "behaves like an array" do
    mapped = candidates.map(&:path)

    expect(mapped).to eq(files.map(&:path))
  end

  it "responds to #unique" do
    candidates.add(files.first)

    result = candidates.unique

    expect(result.map(&:path)).to eq(files.map(&:path))
  end

  it "filters out files that are not#of_types" do
    candidate = Mj::AlternativeFile::Candidate.new(path: "foo.rb", type: "foo")
    candidates.add(candidate)

    result = candidates.of_types(%w[controller foo])

    expect(result.map(&:type)).to eq(%w[controller foo])
  end
end
