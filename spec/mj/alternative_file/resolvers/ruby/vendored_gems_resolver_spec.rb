# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mj::AlternativeFile::Resolvers::Ruby::VendoredGemsResolver do
  subject(:resolver) { described_class.new }

  let(:model_file) { "components/core/app/model/core/user.rb" }
  let(:model_spec) { "components/core/spec/model/core/user_spec.rb" }
  let(:model_test) { "components/core/test/model/core/user_test.rb" }

  let(:lib_file) { "components/core/lib/core/foo.rb" }
  let(:lib_spec) { "components/core/spec/lib/core/foo_spec.rb" }
  let(:lib_test) { "components/core/test/lib/core/foo_test.rb" }

  before do
    allow(Dir).to receive(:[]).and_return([])
    allow(Dir).to receive(:[]).with("components/core/*.gemspec").and_return(["core.gemspec"])
  end

  it "extends base class" do
    expect(resolver).to be_a(Mj::AlternativeFile::Resolvers::Base)
  end

  it "does not resolve any ruby file" do
    expect(resolve("foo.rb")).to be_empty
  end

  it "resolves model's spec" do
    result = resolve(model_file)

    expect(result).to include(create_candidate(model_spec, "spec"))
  end

  it "resolves model's minitest" do
    result = resolve(model_file)

    expect(result).to include(create_candidate(model_test, "minitest"))
  end

  it "resolves lib's spec" do
    result = resolve(lib_file)

    expect(result).to include(create_candidate(lib_spec, "spec"))
  end

  it "resolves lib's minitest" do
    result = resolve(lib_file)

    expect(result).to include(create_candidate(lib_test, "minitest"))
  end

  it "resolves spec's model" do
    result = resolve(model_spec)

    expect(result).to include(create_candidate(model_file, "model"))
  end

  it "resolves test's model" do
    result = resolve(model_test)

    expect(result).to include(create_candidate(model_file, "model"))
  end

  it "resolves lib spec's model" do
    result = resolve(lib_spec)

    expect(result).to include(create_candidate(lib_file, "lib"))
  end

  it "resolves lib test's model" do
    result = resolve(lib_test)

    expect(result).to include(create_candidate(lib_file, "lib"))
  end
end
