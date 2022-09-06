# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mj::AlternativeFile::Resolvers::Ruby::PackwerkResolver do
  subject(:resolver) { described_class.new }

  let(:public_file) { "packages/package_name/app/public/clients/package_name/bar.rb" }
  let(:private_file) { "packages/package_name/app/clients/package_name/bar.rb" }
  let(:spec_file) { "packages/package_name/spec/clients/package_name/bar_spec.rb" }
  let(:test_file) { "packages/package_name/test/clients/package_name/bar_test.rb" }

  it "extends base class" do
    expect(resolver).to be_a(Mj::AlternativeFile::Resolvers::Base)
  end

  it "does not resolve any ruby file" do
    expect(resolve("foo.rb")).to be_empty
  end

  it "resolves spec from a private file" do
    result = resolve(private_file)

    expect(result).to include(create_candidate(spec_file, "spec"))
  end

  it "resolves minitest from a private file" do
    result = resolve(private_file)

    expect(result).to include(create_candidate(test_file, "minitest"))
  end

  it "resolves spec from a public file" do
    result = resolve(public_file)

    expect(result).to include(create_candidate(spec_file, "spec"))
  end

  it "resolves minitest from a public file" do
    result = resolve(public_file)

    expect(result).to include(create_candidate(test_file, "minitest"))
  end

  it "resolves private model from a spec file" do
    result = resolve(spec_file)

    expect(result).to include(create_candidate(private_file, "model"))
  end

  it "resolves public model from a spec file" do
    result = resolve(spec_file)

    expect(result).to include(create_candidate(public_file, "model"))
  end

  it "resolves private model from a minitest file" do
    result = resolve(test_file)

    expect(result).to include(create_candidate(private_file, "model"))
  end

  it "resolves public model from a minitest file" do
    result = resolve(test_file)

    expect(result).to include(create_candidate(public_file, "model"))
  end
end
