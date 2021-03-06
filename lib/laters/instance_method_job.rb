# frozen_string_literal: true

module Laters
  class InstanceMethodJob < ActiveJob::Base
    def perform(object, method_name, *args)
      if object.respond_to? :id
        Rails.logger.info "Calling deferred #{method_name} on #{object.class} ##{object.id}"
      else
        Rails.logger.info "Calling deferred #{object.class}##{method_name}"
      end

      object.run_callbacks(:laters) { object.send(method_name, *args) }
    end
  end
end
