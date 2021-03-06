module Bugsnag::Rails
  module ActiveRecordRescue
    KINDS = [:commit, :rollback].freeze

    def run_callbacks(kind, *args, &block)
      if KINDS.include?(kind)
        begin
          super
        rescue StandardError => exception
          # This exception will NOT be escalated, so notify it here.
          Bugsnag.auto_notify(exception, {
            :severity_reason => {
              :type => Bugsnag::Notification::UNHANDLED_EXCEPTION_MIDDLEWARE,
              :attributes => {
                :framework => "Rails"
              }
            }
          })
          raise
        end
      else
        # Let the post process handle the exception
        super
      end
    end
  end
end
