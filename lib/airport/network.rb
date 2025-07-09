# frozen_string_literal: true

require 'net/http'
require 'uri'

module Airport
  # A networking object used to make requests to Hangar, Paper's plugin service.
  class Hangar
    # Too many redirects occurred.
    class TooManyRedirects < StandardError; end

    # The base URL for all HTTP requests to Hangar.
    API_BASE = 'https://hangar.papermc.io/api/v1'

    def initialize(limit = 10)
      @request_limit = limit
    end

    # Make a request to a specific endpoint.
    def request(endpoint)
      rq_url = URI(API_BASE + endpoint)
      _rq(rq_url, @request_limit)
    end

    # MARK: Private

    private

    def _rq(url, limit = 10)
      raise TooManyRedirects if limit.negative?

      response = Net::HTTP.get_response(URI(url))
      case response
      when Net::HTTPSuccess
        response
      when Net::HTTPRedirection
        _rq_redirect(response, limit)
      end
    end

    def _rq_redirect(response, limit)
      real_loc = response['location']
      unless real_loc.start_with? 'https://'
        warn "Response location didn't start with http://, assuming to use hostname."
        real_loc = "https://#{response.uri.hostname}#{real_loc}"
      end
      puts "Redirecting to: #{real_loc}"
      _rq(URI(real_loc), limit - 1)
    end
  end
end
