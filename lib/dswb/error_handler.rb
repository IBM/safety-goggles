require "exception_notification"

module Dswb
  class ErrorHandler
    ERROR_CODES = {
      "ActionController::ParameterMissing" => 422,
      "ActionController::UnpermittedParameters" => 422,
      "ActiveModel::ValidationError" => 422,
      "ActiveRecord::RecordInvalid" => 422,
      "ActiveRecord::RecordNotFound" => 404,
      "ArgumentError" => 422,
      "Dswb::RecordNotFoundError" => 404,
      "Dswb::UnauthorizedError" => 401,
      "SecurityError" => 403
    }.freeze

    SEVERITIES = {
      500 => "fatal",
      401 => "error",
      403 => "error"
    }.freeze

    def self.handle_error(error, env = ErrorHandler.guess_env)
      logger.debug("::handle_error called with #{error}, #{env}")
      code = ERROR_CODES.fetch(error.class.to_s, 500) if code.nil?

      logger.error("ERROR: #{code} \n#{error.class} \n#{error}")
      logger.error(get_backtrace(error).join("\n"))

      handle_serious_error(error, code, env) if serious_env?

      code
    end

    # :nocov:
    def self.handle_serious_error(error, code, env)
      logger.debug("::handle_serious_error called with #{error}, #{code}, #{env}")
      severity = SEVERITIES.fetch(code, "warning")

      Raven.capture_exception(error,
        extra: { nice_backtrace: get_backtrace(error) },
        level: severity,
        tags:  { code: code, class: error.class })

      if %w(fatal).include?(severity) && !defined?(ExceptionNotifier).nil?
        ExceptionNotifier.notify_exception(error,
          env:  env,
          data: { message: error.to_s })
      end
    end
    # :nocov:

    def self.serious_env?
      return false unless defined?(Rails)
      Rails.env.production? || Rails.env.staging?
    end

    def self.get_backtrace(error)
      return [] unless error.respond_to?(:backtrace)
      return [] if error.backtrace.nil?
      error.backtrace.reject { |line| %r{/gems/}.match(line).present? }
    end

    def self.logger
      return Rails.logger if defined?(Rails) && Rails.respond_to?(:logger) && Rails.logger.present?
      Logger.new(STDOUT)
    end

    def self.guess_env
      return Rails.env if defined?(Rails) && Rails.respond_to?(:env) && Rails.env.present?
      "development"
    end
  end
end
