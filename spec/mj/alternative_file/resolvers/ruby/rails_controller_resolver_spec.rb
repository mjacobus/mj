# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::Resolvers::Ruby::RailsControllerResolver do
  subject(:resolver) { described_class.new }

  let(:controller_spec) { "spec/controllers/foos/bars_controller_spec.rb" }
  let(:request_spec) { "spec/requests/foos/bars_spec.rb" }
  let(:request_test) { "test/requests/foos/bars_test.rb" }
  let(:system_spec) { "spec/system/foos/bars_spec.rb" }
  let(:system_test) { "test/system/foos/bars_test.rb" }
  let(:controller_test) { "test/controllers/foos/bars_controller_test.rb" }
  let(:integration_spec) { "spec/integration/foos/bars_controller_spec.rb" }
  let(:integration_with_controller_spec) { "spec/integration/controllers/foos/bars_controller_spec.rb" }
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

  it "resolves controller from test" do
    result = resolve(controller_test)

    expect(result).to include(create_candidate(controller, "controller"))
  end

  it "resolves controller request spec" do
    result = resolve(controller)

    expect(result).to include(create_candidate(request_spec, "request_spec"))
  end

  it "resolves controller request test" do
    result = resolve(controller)

    expect(result).to include(create_candidate(request_test, "request_test"))
  end

  it "resolves controller system spec" do
    result = resolve(controller)

    expect(result).to include(create_candidate(system_spec, "system_spec"))
  end

  it "resolves controller system test" do
    result = resolve(controller)

    expect(result).to include(create_candidate(system_test, "system_test"))
  end

  it "resolves controller from spec" do
    result = resolve(controller_spec)

    expect(result).to include(create_candidate(controller, "controller"))
  end

  it "resolves controller integration test" do
    result = resolve(controller)

    expect(result).to include(create_candidate(integration_test, "integration_test"))
  end

  it "resolves controller integration spec" do
    result = resolve(controller)

    expect(result).to include(create_candidate(integration_spec, "integration_spec"))
  end

  it "resolves controller integration with controller subfolder spec" do
    result = resolve(controller)

    expect(result).to include(create_candidate(integration_with_controller_spec, "integration_spec"))
  end

  it "resolves controller integration with controller subfolder spec" do
    result = resolve(integration_with_controller_spec)

    expect(result).to include(create_candidate(controller, "controller"))
  end

  it "resolves controller from integration test" do
    result = resolve(integration_test)

    expect(result).to include(create_candidate(controller, "controller"))
  end

  it "resolves controller from integration spec" do
    result = resolve(integration_spec)

    expect(result).to include(create_candidate(controller, "controller"))
  end

  it "resolves controller from request spec" do
    result = resolve(request_spec)

    expect(result).to include(create_candidate(controller, "controller"))
  end

  it "resolves controller from request test" do
    result = resolve(request_test)

    expect(result).to include(create_candidate(controller, "controller"))
  end

  it "resolves controller from system spec" do
    result = resolve(system_spec)

    expect(result).to include(create_candidate(controller, "controller"))
  end

  it "resolves controller from system test" do
    result = resolve(system_test)

    expect(result).to include(create_candidate(controller, "controller"))
  end
end
