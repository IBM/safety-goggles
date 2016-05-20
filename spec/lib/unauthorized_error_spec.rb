require "dswb/unauthorized_error"

RSpec.describe(Dswb::UnauthorizedError) do
  describe :new do
    it "can be thrown" do
      expect { raise Dswb::UnauthorizedError, "This is an error" }.to raise_error(Dswb::UnauthorizedError)
    end
  end
end
