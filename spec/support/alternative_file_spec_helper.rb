# frozen_string_literal: true

module AlternativeFileSpecHelper
  def create_candidate(path, type)
    Mj::AlternativeFile::Candidate.new(path: path, type: type)
  end

  def resolve(file)
    described_class.new.resolve(Mj::AlternativeFile::CurrentFile.new(file))
  end
end
