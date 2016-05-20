require "action_controller"
require "active_model"
require "active_model/validations"
require "active_model/validator"
require "active_record"
require "dswb/unauthorized_error"
require "rails"

module Dswb
  class ErrorHandler
    ERROR_CODES = {
      ActionController::ParameterMissing => 422,
      ActionController::UnpermittedParameters => 422,
      ActiveModel::ValidationError => 422,
      ActiveRecord::RecordInvalid => 422,
      ActiveRecord::RecordNotFound => 404,
      ArgumentError => 422,
      Dswb::UnauthorizedError => 401,
      SecurityError => 403
    }.freeze

    SEVERITIES = {
      500 => "fatal",
      401 => "error",
      403 => "error"
    }.freeze

    def self.handle_error(error, code = nil, env = Rails.env)
      logger.debug("::handle_error called with #{error}, #{code}")
      code = ERROR_CODES.fetch(error.class, 500) if code.nil?

      logger.error("ERROR: #{code} \n#{error.class} \n#{error}")
      logger.error(get_backtrace(error).join("\n"))

      handle_serious_error(error, code, env) if serious_env?

      code
    end

    # :nocov:
    def self.handle_serious_error(error, code, env)
      logger.debug("::handle_serious_error called with #{error}, #{code}")
      severity = SEVERITIES.fetch(code, "warning")

      Raven.capture_exception(error,
        extra: { nice_backtrace: get_backtrace(error) },
        level: severity,
        tags:  { code: code, class: error.class })

      if %w(fatal).include?(severity)
        ExceptionNotifier.notify_exception(error,
          env:  env,
          data: { message: error.to_s })
      end
    end
    # :nocov:

    def self.serious_env?
      Rails.env.production? || Rails.env.staging?
    end

    def self.get_backtrace(error)
      return [] unless error.respond_to?(:backtrace)
      error.backtrace.reject { |line| %r{/gems/}.match(line).present? }
    end

    def self.logger
      return Rails.logger if Rails.respond_to?(:logger) && Rails.logger.present?
      Logger.new(STDOUT)
    end
  end
end
