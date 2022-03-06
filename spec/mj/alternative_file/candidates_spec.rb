# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::Candidates do
  subject(:candidates) { described_class.new(files) }

  let(:files) do
    [
      create_item("spec/mj/alternative_file/candidates_spec.rb", "spec"),
      create_item("foo_controller.rb", "controller")
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
    candidate = create_item("foo.rb", "foo")
    candidates.add(candidate)

    result = candidates.of_types(%w[controller foo])

    expect(result.map(&:type)).to eq(%w[controller foo])
  end

  def create_item(path, type)
    Mj::AlternativeFile::Candidate.new(path: path, type: type)
  end
end
