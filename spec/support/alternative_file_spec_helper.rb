# frozen_string_literal: true

module AlternativeFileSpecHelper
  def create_candidate(path, type)
    Mj::AlternativeFile::Candidate.new(path: path, type: type)
  end

  def resolve(file)
    described_class.new.resolve(Mj::AlternativeFile::CurrentFile.new(file))
  end

  def resolvers
    @resolvers ||= Mj::AlternativeFile::Resolver.new
  end

  def mock_resolver(&block)
    MockResolver.new(&block)
  end

  class MockResolver < Mj::AlternativeFile::Resolvers::Base
    def initialize(&block)
      @block = block
    end

    private

    def apply_to?(_file)
      true
    end

    def add_candidates(file, candidates)
      parts = @block.call(file)
      add_candidate(parts[0], parts[1], to: candidates)
    end
  end
end
