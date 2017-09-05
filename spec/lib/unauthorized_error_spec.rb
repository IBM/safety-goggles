require "safety_goggles/unauthorized_error"

RSpec.describe(SafetyGoggles::UnauthorizedError) do
  describe :new do
    it "can be thrown" do
      expect { raise SafetyGoggles::UnauthorizedError, "This is an error" }.to(
        raise_error(SafetyGoggles::UnauthorizedError)
      )
    end
  end
end
