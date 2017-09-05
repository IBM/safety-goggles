require "safety_goggles/record_not_found_error"

RSpec.describe(SafetyGoggles::RecordNotFoundError) do
  describe :new do
    it "can be thrown" do
      expect { raise SafetyGoggles::RecordNotFoundError, "This is an error" }.to(
        raise_error(SafetyGoggles::RecordNotFoundError)
      )
    end
  end
end
