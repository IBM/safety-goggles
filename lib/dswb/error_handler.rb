require "dswb/unauthorized_error"

module Dswb
  class ErrorHandler
    ERROR_CODES = {
      ActionController::ParameterMissing => 422,
      ActionController::UnpermittedParameters => 422,
      ActiveModel::ValidationError => 422,
      ActiveRecord::RecordInvalid => 422,
      ActiveRecord::RecordNotFound => 404,
      ArgumentError => 422,
      Dswb::UnauthorizedError => 401
    }.freeze

    SEVERITIES = {
      500 => "fatal",
      401 => "error",
      403 => "error"
    }.freeze

    def self.handle_error(error, code = nil)
      Rails.logger.debug("::handle_error called with #{error}, #{code}")
      code = ERROR_CODES.fetch(error.class, 500) if code.nil?

      Rails.logger.error("ERROR: #{code} \n#{error.class} \n#{error}")
      Rails.logger.error(get_backtrace(error).join("\n"))

      handle_serious_error(error, code) if serious_env?

      code
    end

    # :nocov:
    def self.handle_serious_error(error, code)
      Rails.logger.debug("::handle_serious_error called with #{error}, #{code}")
      severity = SEVERITIES.fetch(code, "warning")

      Raven.capture_exception(error,
        extra: { nice_backtrace: get_backtrace(error) },
        level: severity,
        tags:  { code: code, class: error.class })

      if %w(fatal).include?(severity)
        ExceptionNotifier.notify_exception(error,
          env:  ActiveSupport::StringInquirer.new(ENV.fetch("RAILS_ENV")),
          data: { message: error.to_s })
      end
    end
    # :nocov:

    def self.get_backtrace(error)
      return [] unless error.respond_to?(:backtrace)
      error.backtrace.reject { |line| %r{/gems/}.match(line).present? }
    end

    def self.serious_env?
      Rails.env.production? || Rails.env.staging?
    end
  end
end
