require "dswb/record_not_found_error"

RSpec.describe(Dswb::RecordNotFoundError) do
  describe :new do
    it "can be thrown" do
      expect { raise Dswb::RecordNotFoundError, "This is an error" }.to raise_error(Dswb::RecordNotFoundError)
    end
  end
end
