module Kucoin
  module Rest
    module Authentication
      
      def authenticate!(method, path, params: nil, data: nil)
        data              =   sign_message(method, path, params: params, data: data)
        
        {
          'KC-API-KEY'        =>  self.configuration.key,
          'KC-API-SIGN'       =>  data[:signature],
          'KC-API-TIMESTAMP'  =>  data[:timestamp],
          'KC-API-PASSPHRASE' =>  self.configuration.passphrase
        }
      end
      
      def timestamp
        (Time.now.to_f * 1000).to_i.to_s
      end
      
      def sign_message(method, path, params: nil, data: nil)
        path              =   signature_path(path)
        timestamped       =   timestamp
        params            =   compose_params(params)
        data              =   json_data(data)
        message           =   "#{timestamped}#{method.upcase}#{path}#{params}#{data}"
        signature         =   ::Kucoin::Utilities::Encoding.sign(message, secret: self.configuration.secret)
        
        return {timestamp: timestamped, signature: signature}
      end
      
      def compose_params(params)
        return params unless params.is_a? Hash
        uri               =   Addressable::URI.new
        uri.query_values  =   params
        query             =   uri.query
        
        return !query.to_s.empty? ? "?#{query}" : nil
      end
      
      def json_data(data)
        return nil if data.nil? || (data.respond_to?(:empty?) && data.empty?)
        return data.to_json
      end
            
    end
  end  
end
