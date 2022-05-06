module Kucoin
  class Configuration
    attr_accessor :api_url, :api_version, :key, :secret, :passphrase, :faraday
    
    def initialize
      self.api_url          =   "https://api.kucoin.com"
      self.api_version      =   2
      
      self.key              =   nil
      self.secret           =   nil
      self.passphrase       =   nil
      
      self.faraday          =   {
        adapter:    :net_http,
        user_agent: 'KuCoin Ruby',
        verbose:    false
      }
    end
    
    def verbose_faraday?
      self.faraday.fetch(:verbose, false)
    end
    
  end
end
