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

  describe "#after" do
    let(:files) do
      [
        create_item("one.rb", "regular"),
        create_item("two.rb", "regular"),
        create_item("three.rb", "regular"),
        create_item("four.rb", "regular")
      ]
    end

    it "returns the item after the reference file when reference exists" do
      results = [
        candidates.after(current("one.rb")),
        candidates.after(current("two.rb")),
        candidates.after(current("three.rb"))
      ]

      expect(results.map(&:path)).to eq(["two.rb", "three.rb", "four.rb"])
    end

    it "circles back to the first element when reference file is the last element" do
      result = candidates.after(current("four.rb"))

      expect(result.path).to eq("one.rb")
    end

    it "return the first item when reference file does not exist" do
      result = candidates.after(current("none.rb"))

      expect(result.path).to eq("one.rb")
    end
  end

  describe "#before" do
    let(:files) do
      [
        create_item("one.rb", "regular"),
        create_item("two.rb", "regular"),
        create_item("three.rb", "regular"),
        create_item("four.rb", "regular")
      ]
    end

    it "returns the item before the reference file when reference exists" do
      results = [
        candidates.before(current("two.rb")),
        candidates.before(current("three.rb")),
        candidates.before(current("four.rb"))
      ]

      expect(results.map(&:path)).to eq(["one.rb", "two.rb", "three.rb"])
    end

    it "circles back to the last element when reference file is the last element" do
      result = candidates.before(current("one.rb"))

      expect(result.path).to eq("four.rb")
    end

    it "return the last item when reference file does not exist" do
      result = candidates.before(current("none.rb"))

      expect(result.path).to eq("four.rb")
    end
  end

  def create_item(path, type)
    Mj::AlternativeFile::Candidate.new(path: path, type: type)
  end

  def current(path)
    Mj::AlternativeFile::CurrentFile.new(path)
  end
end
