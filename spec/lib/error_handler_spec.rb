require "action_controller"
require "active_model"
require "active_model/validations"
require "active_model/validator"
require "active_record"

require "dswb/error_handler"
require "dswb/record_not_found_error"
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

    ERROR_CODES = {
      ActionController::ParameterMissing => 422,
      ActionController::UnpermittedParameters => 422,
      ActiveModel::ValidationError => 422,
      ActiveRecord::RecordInvalid => 422,
      ActiveRecord::RecordNotFound => 404,
      ArgumentError => 422,
      Dswb::RecordNotFoundError => 404,
      Dswb::UnauthorizedError => 401,
      SecurityError => 403
    }.freeze

    it "handles 401s" do
      expect(Dswb::ErrorHandler.handle_error(Dswb::UnauthorizedError.new("Hi"))).to eq(401)
    end

    it "handles 403s" do
      expect(Dswb::ErrorHandler.handle_error(SecurityError.new("Hi"))).to eq(403)
    end

    it "handles 404s" do
      expect(Dswb::ErrorHandler.handle_error(ActiveRecord::RecordNotFound.new("Hi"))).to eq(404)
      expect(Dswb::ErrorHandler.handle_error(Dswb::RecordNotFoundError.new("Hi"))).to eq(404)
    end

    it "handles 422s" do
      expect(Dswb::ErrorHandler.handle_error(ActionController::ParameterMissing.new("Hi"))).to eq(422)
      expect(Dswb::ErrorHandler.handle_error(ActionController::UnpermittedParameters.new(["Hi"]))).to eq(422)
      expect(Dswb::ErrorHandler.handle_error(ArgumentError.new("Hi"))).to eq(422)
    end

    it "handles 422s with ActiveModel" do
      model = double("model")
      allow(model).to receive_message_chain(:errors, :full_messages) { [] }
      allow(model).to receive_message_chain(:class, :i18n_scope) { "" }

      # TODO: Figure out how to fake one of these
      expect(Dswb::ErrorHandler.handle_error(ActiveModel::ValidationError.new(model))).to eq(422)
      expect(Dswb::ErrorHandler.handle_error(ActiveRecord::RecordInvalid.new(model))).to eq(422)
    end

    it "handles 500s" do
      expect(Dswb::ErrorHandler.handle_error(StandardError.new("Hi"))).to eq(500)
    end
  end

  describe :serious_env? do
    it "takes url as a parameter" do
      expect([true, false]).to include(Dswb::ErrorHandler.serious_env?)
    end
  end
end
