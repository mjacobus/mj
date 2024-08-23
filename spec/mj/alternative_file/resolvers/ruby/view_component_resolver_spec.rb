# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::Resolvers::Ruby::ViewComponentResolver do
  subject(:resolver) { described_class.new }

  let(:component_class) { "app/components/foos/bar_component.rb" }
  let(:component_spec) { "spec/components/foos/bar_component_spec.rb" }
  let(:component_test) { "test/components/foos/bar_component_test.rb" }
  let(:component_template) { "app/components/foos/bar_component.html.erb" }

  it "extends base class" do
    expect(resolver).to be_a(Mj::AlternativeFile::Resolvers::Base)
  end

  it "resolves template from component class" do
    result = resolve(component_class)

    expect(result).to include(create_candidate(component_template, "component_template"))
  end

  it "resolves component_class from template" do
    result = resolve(component_template)

    expect(result).to include(create_candidate(component_class, "component_class"))
  end

  it "resolves template from spec" do
    result = resolve(component_spec)

    expect(result).to include(create_candidate(component_template, "component_template"))
  end

  it "resolves template from minitest" do
    result = resolve(component_test)

    expect(result).to include(create_candidate(component_template, "component_template"))
  end

  context "when component does not have a _component suffix" do
    let(:component_class) { "app/components/foos/bar.rb" }
    let(:component_spec) { "spec/components/foos/bar_spec.rb" }
    let(:component_test) { "test/components/foos/bar_test.rb" }
    let(:component_template) { "app/components/foos/bar.html.erb" }

    it "resolves template from component class" do
      result = resolve(component_class)

      expect(result).to include(create_candidate(component_template, "component_template"))
    end

    it "resolves component_class from template" do
      result = resolve(component_template)

      expect(result).to include(create_candidate(component_class, "component_class"))
    end

    it "resolves template from spec" do
      result = resolve(component_spec)

      expect(result).to include(create_candidate(component_template, "component_template"))
    end

    it "resolves template from minitest" do
      result = resolve(component_test)

      expect(result).to include(create_candidate(component_template, "component_template"))
    end
  end
end
