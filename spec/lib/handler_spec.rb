# frozen_string_literal: true

require "action_controller"
require "active_model"
require "active_model/validations"
require "active_model/validator"
require "active_record"

require "net/ldap"

require "safety_goggles/handler"
require "safety_goggles/record_not_found_error"
require "safety_goggles/unauthorized_error"

# rubocop:disable Metrics/BlockLength
RSpec.describe(SafetyGoggles::Handler) do
  describe :handle_error do
    it "doesn't throw any errors" do
      raise SafetyGoggles::UnauthorizedError, "Just testing"
    rescue StandardError => e
      expect { SafetyGoggles::Handler.handle_error(e) }.not_to raise_error
    end

    ERROR_CODES = {
      ActionController::ParameterMissing => 422,
      ActionController::UnpermittedParameters => 422,
      ActiveModel::ValidationError => 422,
      ActiveRecord::RecordInvalid => 422,
      ActiveRecord::RecordNotFound => 404,
      ActiveRecord::RecordNotUnique => 422,
      ArgumentError => 422,
      SafetyGoggles::RecordNotFoundError => 404,
      SafetyGoggles::UnauthorizedError => 401,
      SecurityError => 403
    }.freeze

    it "handles 401s" do
      expect(SafetyGoggles::Handler.handle_error(SafetyGoggles::UnauthorizedError.new("Hi"))).to eq(401)
    end

    it "handles 403s" do
      expect(SafetyGoggles::Handler.handle_error(SecurityError.new("Hi"))).to eq(403)
    end

    it "handles 404s" do
      expect(SafetyGoggles::Handler.handle_error(ActiveRecord::RecordNotFound.new("Hi"))).to eq(404)
      expect(SafetyGoggles::Handler.handle_error(SafetyGoggles::RecordNotFoundError.new("Hi"))).to eq(404)
    end

    it "handles 422s" do
      expect(SafetyGoggles::Handler.handle_error(ActionController::ParameterMissing.new("Hi"))).to eq(422)
      expect(SafetyGoggles::Handler.handle_error(ActiveRecord::RecordNotUnique.new("Hi"))).to eq(422)
      expect(SafetyGoggles::Handler.handle_error(ActionController::UnpermittedParameters.new(["Hi"]))).to eq(422)
      expect(SafetyGoggles::Handler.handle_error(ArgumentError.new("Hi"))).to eq(422)
      expect(SafetyGoggles::Handler.handle_error(Net::LDAP::Error.new("Hi"))).to eq(422)
    end

    it "handles 422s with ActiveModel" do
      model = double("model")
      allow(model).to receive_message_chain(:errors, :full_messages) { [] }
      allow(model).to receive_message_chain(:class, :i18n_scope) { "" }

      # TODO: Figure out how to fake one of these
      expect(SafetyGoggles::Handler.handle_error(ActiveModel::ValidationError.new(model))).to eq(422)
      expect(SafetyGoggles::Handler.handle_error(ActiveRecord::RecordInvalid.new(model))).to eq(422)
    end

    it "handles 500s" do
      expect(SafetyGoggles::Handler.handle_error(StandardError.new("Hi"))).to eq(500)
    end
  end

  describe :serious_env? do
    it "takes url as a parameter" do
      expect([true, false]).to include(SafetyGoggles::Handler.serious_env?)
    end
  end
end
# rubocop:enable Metrics/BlockLength
