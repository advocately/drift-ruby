require 'net/http'
require 'multi_json'

module Drift
  DEFAULT_URI = 'https://event.api.drift.com'.freeze

  class Client
    class InvalidRequest < RuntimeError; end
    class InvalidResponse < RuntimeError
      attr_reader :response

      def initialize(message, response)
        @message = message
        @response = response
      end
    end

    def initialize(org_id, options = {})
      @org_id = org_id
      @base_uri = options[:base_uri] || DEFAULT_URI
    end

    def identify(user_id, attributes = {})
      body = {
        attributes: attributes,
        userId: user_id,
        orgId: @org_id
      }

      perform_request('identify', body)
    end

    def track(user_id, event_name, attributes = {})
      occurred_at = attributes.delete(:occurred_at)
      body = {
        userId: user_id,
        orgId: @org_id,
        event: event_name,
        attributes: attributes,
        createdAt: occurred_at
      }

      perform_request('track', body)
    end

  private

    def perform_request(path, attributes)
      uri = URI.join(@base_uri, path)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(uri.path)
      request['content-type'] = 'application/json'
      request.body = attributes.to_json

      response = http.request(request)
      handle_json_response(response)
    end

    def handle_json_response(response)
      case response.code.to_i
      when 200, 201, 202, 204
        Utils.symbolize_keys(JSON.load(response.body))
      when 401
        raise AuthenticationError, response
      when 406
        raise UnsupportedFormatRequestedError, response
      when 422
        raise ResourceValidationError, response
      when 503
        raise ServiceUnavailableError, response
      else
        raise GeneralAPIError, response
      end
    end
  end
end
