require "dswb/error_handler"
require "dswb/unauthorized_error"

RSpec.describe(Dswb::ErrorHandler) do
  describe :handle_error do
    it "doesn't throw any errors" do
      begin
        raise Dswb::UnauthorizedError, "Just testing"
      rescue => error
        expect { Dswb::ErrorHandler.handle_error(error) }.not_to raise_error
      end
    end
  end

  describe :serious_env? do
    it "takes url as a parameter" do
      expect(Dswb::ErrorHandler.serious_env?).to be_in([true, false])
    end
  end
end
