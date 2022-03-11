# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::Resolvers::Ruby::RailsControllerResolver do
  subject(:resolver) { described_class.new }

  def resolve(file)
    described_class.new.resolve(Mj::AlternativeFile::CurrentFile.new(file))
  end

  let(:controller_spec) { "spec/controllers/foos/bars_controller_spec.rb" }
  let(:controller_test) { "test/controllers/foos/bars_controller_test.rb" }
  let(:integration_spec) { "spec/integration/foos/bars_controller_spec.rb" }
  let(:integration_test) { "test/integration/foos/bars_controller_test.rb" }
  let(:controller) { "app/controllers/foos/bars_controller.rb" }

  it "extends base class" do
    expect(resolver).to be_a(Mj::AlternativeFile::Resolvers::Base)
  end

  it "does not resolve any ruby file" do
    expect(resolve("foo.rb")).to be_empty
  end

  it "resolves controller test" do
    result = resolve(controller)

    expect(result).to include(create_candidate(controller_test, "controller_test"))
  end

  it "resolves controller spec" do
    result = resolve(controller)

    expect(result).to include(create_candidate(controller_spec, "controller_spec"))
  end

  it "resolves controller integration test" do
    result = resolve(controller)

    expect(result).to include(create_candidate(integration_test, "integration_test"))
  end

  it "resolves controller integration spec" do
    result = resolve(controller)

    expect(result).to include(create_candidate(integration_spec, "integration_spec"))
  end

  it "resolves controller from integration test" do
    result = resolve(integration_test)

    expect(result).to include(create_candidate(controller, "controller"))
  end

  it "resolves controller from integration spec" do
    result = resolve(integration_spec)

    expect(result).to include(create_candidate(controller, "controller"))
  end
end
