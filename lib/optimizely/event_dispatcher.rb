require 'httparty'

module Optimizely
  class NoOpEventDispatcher
    # Class providing dispatch_event method which does nothing.

    def dispatch_event(event)
    end
  end

  class EventDispatcher
    POST_HEADERS = { 'Content-Type' => 'application/json' }
    REQUEST_TIMEOUT = 10

    def dispatch_event(event)
      # Dispatch the event being represented by the Event object.
      #
      # event - Event object

      if event.http_verb == :get
        begin
          HTTParty.get(event.url, query: event.params, timeout: REQUEST_TIMEOUT)
        rescue Timeout::Error => e
          return e
        end
      elsif event.http_verb == :post
        begin
          HTTParty.post(event.url,
                   body: event.params.to_json,
                   headers: POST_HEADERS,
                   timeout: REQUEST_TIMEOUT)
        rescue Timeout::Error => e
          return e
        end
      end
    end
  end
end
