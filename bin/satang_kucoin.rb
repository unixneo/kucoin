# Example file to check the price of one coin on Satang
# and compare outcomes after transfering to Kucoin
# and converting to BTC using trading pairs

def satang(delay=5,thb=20000,fx=34.19,coin='TRX',show_btc_thb=false)
    version="0.0.1.31"
    
    # Set up Satang Exchange API Parameters
    require 'net/http'
    source ='https://satangcorp.com/api/orderbook-tickers/'
    tt_rate=fx
    thai_baht = thb
    # satang pro fee is current 0.2 percent per trade
    satang_fee = thai_baht *  0.002000
    satang_pair="#{coin}_THB"
    kucoin_withdraw_btc_fee = 0.0005
   
    # Set up Kucoin Exchange API Parameters
    require 'kucoin'
    Kucoin.configure do |config|
        config.key          =   ENV['KUCOIN_API_KEY']
        config.secret       =   ENV['KUCOIN_API_SECRET']
        config.passphrase   =   ENV['KUCOIN_API_PASSPHRASE']
    end

    kucoin_pair="#{coin}-BTC"
    coin_tether="#{coin}-USDT"

    kc_client = Kucoin::Rest::Client.new

    while true do
        output = []
        # Do Satang Exchange API and Simple Math
        resp = Net::HTTP.get_response(URI.parse(source))
        data = resp.body
        result = JSON.parse(data)
        
        if result[satang_pair].nil?
            puts "ERROR #{coin} NOT AVAILBLE ON SATANG PRO"
            break
        end
        coin_thb = ((result[satang_pair]["bid"]['price'].to_f.round(5) + result[satang_pair]["ask"]['price'].to_f.round(5))/2).round(3)
        btc_thb = ((result['BTC_THB']["bid"]['price'].to_f.round(5) + result['BTC_THB']["ask"]['price'].to_f.round(5))/2).round(3)
        
        # The network fee for TRX is 1 TRX
        # Needs lookup table for other coins
        if coin.include? 'TRX'
            total_coin = (((thai_baht - satang_fee)/ coin_thb) - 1.00000).round(10)
        else
            total_coin = ((thai_baht - satang_fee)/ coin_thb).round(10)
        end
        
        # Do Kucoin Exchange API and Simple Math

        if  kc_client.ticker(kucoin_pair).nil?
            puts "ERROR #{coin} PAIR NOT AVAILBLE ON KUCOIN"
            break
        end

        coin_btc = kc_client.ticker(kucoin_pair)['price'].to_f.round(10)
       
        # kucoin charges 0.08 percent when paying trading fees with KSC
        btc = coin_btc * total_coin * (1.00000 - 0.0008)

        # There is no fee on KUCOIN for receiving coin
        #trx_fee = kc_client.ticker(coin_tether)['price'].to_f.round(10)
        
        btc_usd = kc_client.ticker("BTC-USDT")['price'].to_f.round(10)
        total_usd = (btc.round(10) * btc_usd.round(10)).round(2)

        if show_btc_thb
            btc_to_satang = btc.round(10) -kucoin_withdraw_btc_fee.round(10)
            final_thb_from_btc = ((btc_to_satang.round(10) *  btc_thb.round(10)) * (1.0000 -0.0025)).round(10)
        end

        output << "-------------------------------"
        output <<  "TIME #{Time.now}"
        output <<  "USD #{"%.2f" % (thai_baht / tt_rate).round(2)}"
        output <<  "#{coin}-THB #{coin_thb}"
        output <<  "TOTAL #{coin} #{total_coin.round(3)}"
        output <<  "#{coin}-BTC #{"%.9f" %  coin_btc.to_f.round(9)}"
        output <<  "BTC-USD #{"%.2f" % btc_usd.round(2)}"
        if show_btc_thb
            output <<  "KUCOIN BTC WITHDRAWAL FEE #{"%.2f" % (btc_usd.round(2) * kucoin_withdraw_btc_fee.round(10)).round(2)}"
        end
        output <<  "TOTAL BTC #{btc.round(10)}"
        output <<  "BTC-THB #{btc_thb}"
        output <<  "TOTAL USD #{"%.2f" %  total_usd }"
        output <<  "TOTAL THB #{"%.2f" % (total_usd  * tt_rate).round(2)}"
        if show_btc_thb
            output <<  "TOTAL BTC TO SATANG #{"%.9f" % btc_to_satang.round(10)}"
            output <<  "TOTAL BTC_THB #{"%.9f" % final_thb_from_btc.round(10)}"
        end
 
        puts output
        sleep delay
    end

end

satang(5,20000,34.19,'TRX')
