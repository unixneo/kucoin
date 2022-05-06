# KuCoin REST Client in Ruby

This gem provides a REST client to interface with [KuCoin's v2 API](https://docs.kucoin.com).

The webservice client hasn't been implemented yet but will be implemented eventually (pull requests are more than welcome!)

## Getting started

First of all you'll need to get an account on KuCoin, [click here to get one](https://www.kucoin.com).

After setting up your account, head to "Account", locate the "API Management" section and click on "Create API".

## Installation

Add this line to your application's Gemfile:

```ruby
gem "kucoin", git: "https://github.com/unixneo/kucoin"
```

And then execute:

    $ bundle


## Setup

Create e.g. an initializer and configure the client globally:

```bash
export KUCOIN_API_KEY="blah_blah_blah"
export KUCOIN_API_SECRET="blah_blah_blah"
export KUCOIN_API_PASSPHRASE="blah_blah_blah"
```

```ruby
Kucoin.configure do |config|
  config.key          =   ENV['KUCOIN_API_KEY']
  config.secret       =   ENV['KUCOIN_API_SECRET']
  config.passphrase   =   ENV['KUCOIN_API_PASSPHRASE']
end
```

## Usage

See the source and specs for more detailed usage of the available endpoints.

Instantiating a new client using the default configuration (Kucoin.configuration):

```ruby
client = Kucoin::Rest::Client.new
```

Or using a custom configuration:

```ruby
client = Kucoin::Rest::Client.new(configuration: custom_configuration)
```

### Public API

#### Currencies

Fetch all available currencies on KuCoin:

```ruby
client.currencies
=> [#<Kucoin::Models::Currency:0x00007fb62018be28 @currency="XMR", @full_name="Monero", @is_deposit_enabled=true, @is_withdraw_enabled=true, @name="XMR", @precision=8.0, @withdrawal_min_fee=0.0001, @withdrawal_min_size=0.01>, ... ]
```

Fetch a specific currency:

```ruby
client.currency("XRP")
=> #<Kucoin::Models::Currency:0x00007fb620204eb8 @currency="XRP", @full_name="XRP", @is_deposit_enabled=true, @is_withdraw_enabled=true, @name="XRP", @precision=8.0, @withdrawal_min_fee=0.5, @withdrawal_min_size=25.0>
```

Fetch all currencies calculated in USD:

```ruby
client.prices(base: "USD")
=> {"LOKI"=>0.20547367,
 "EXY"=>0.02197239,
 "IOTX"=>0.01074736,
 "MHC"=>0.0318,
 "STQ"=>0.00014569,
 "TFD"=>0.00597076,
 "DOCK"=>0.01409099,
 "SUSD"=>0.9655909, ... }
```

#### Symbols

Fetch all available symbols:

```ruby
client.symbols
=> [#<Kucoin::Models::Symbol:0x00007fb6201aacd8
  @base_currency="REQ",
  @base_increment=0.0001,
  @base_max_size=10000000000.0,
  @base_min_size=1.0,
  @enable_trading=true,
  @fee_currency="ETH",
  @name="REQ-ETH",
  @price_increment=1.0e-07,
  @quote_currency="ETH",
  @quote_increment=1.0e-07,
  @quote_max_size=99999999.0,
  @quote_min_size=0.0001,
  @symbol="REQ-ETH">,
 #<Kucoin::Models::Symbol:0x00007fb6201b99e0
  @base_currency="REQ",
  @base_increment=0.0001,
  @base_max_size=10000000000.0,
  @base_min_size=1.0,
  @enable_trading=true,
  @fee_currency="BTC",
  @name="REQ-BTC",
  @price_increment=1.0e-08,
  @quote_currency="BTC",
  @quote_increment=1.0e-08,
  @quote_max_size=99999999.0,
  @quote_min_size=1.0e-05,
  @symbol="REQ-BTC">, ... ]
```

Fetch all available BTC-traded symbols:

```ruby
client.symbols("BTC")
=> [#<Kucoin::Models::Symbol:0x00007fb62027f578
  @base_currency="REQ",
  @base_increment=0.0001,
  @base_max_size=10000000000.0,
  @base_min_size=1.0,
  @enable_trading=true,
  @fee_currency="BTC",
  @name="REQ-BTC",
  @price_increment=1.0e-08,
  @quote_currency="BTC",
  @quote_increment=1.0e-08,
  @quote_max_size=99999999.0,
  @quote_min_size=1.0e-05,
  @symbol="REQ-BTC">,
 #<Kucoin::Models::Symbol:0x00007fb62027c850
  @base_currency="PAY",
  @base_increment=0.0001,
  @base_max_size=10000000000.0,
  @base_min_size=0.1,
  @enable_trading=true,
  @fee_currency="BTC",
  @name="PAY-BTC",
  @price_increment=1.0e-08,
  @quote_currency="BTC",
  @quote_increment=1.0e-08,
  @quote_max_size=99999999.0,
  @quote_min_size=1.0e-05,
  @symbol="PAY-BTC">, ... ]
```

#### Markets

Get all primary markets:

```ruby
client.markets
=> ["BTC", "ETH", "KCS", "SC", "NEO"]
```

#### Tickers

Get all tickers:

```ruby
client.tickers
=> [#<Kucoin::Models::Ticker:0x00007fb6203656e0
  @buy=9.02e-06,
  @change_price=3.0e-07,
  @change_rate=0.0344,
  @high=9.33e-06,
  @last=9.02e-06,
  @low=8.49e-06,
  @sell=9.08e-06,
  @symbol="LOOM-BTC",
  @vol=334298.77392064,
  @vol_value=2.9684056480569168>,
 #<Kucoin::Models::Ticker:0x00007fb62036f668
  @buy=0.00013327,
  @change_price=9.29e-06,
  @change_rate=0.0744,
  @high=0.00015284,
  @last=0.00013406,
  @low=0.00012313,
  @sell=0.00013487,
  @symbol="BCD-BTC",
  @vol=10864.63264056,
  @vol_value=1.40455145107375>, ... ]
```

Get a specific ticker:

```ruby
client.ticker("XRP-USDT")
=> {"sequence"=>"1556266896565", "bestAsk"=>"0.39717", "size"=>"1931.5854", "price"=>"0.39673", "bestBidSize"=>"525.29", "time"=>1558460956142, "bestBid"=>"0.39637", "bestAskSize"=>"5448.1"}
```

Get market statistics:

```ruby
client.market_stats("XRP-USDT")
=>  #<Kucoin::Models::Ticker:0x00007fb6201cc7c0
 @buy=0.39653,
 @change_price=0.0051,
 @change_rate=0.013,
 @high=0.40632,
 @last=0.39673,
 @low=0.38611,
 @sell=0.39723,
 @symbol="XRP-USDT",
 @time=2019-05-21 17:49:52 UTC,
 @vol=586743.58020803,
 @vol_value=231722.93958312072>
```

### Private/Authenticated API

#### Accounts

List all accounts:

```ruby
client.accounts
=> [#<Kucoin::Models::Account:0x00007fb6202ae328 @available=0.0, @balance=0.0, @currency="ETH", @holds=0.0, @id="ETH_MAIN_ACCOUNT_ID", @type="main">,
 #<Kucoin::Models::Account:0x00007fb6202ad1f8 @available=0.0, @balance=0.0, @currency="USDT", @holds=0.0, @id="USDT_TRADE_ACCOUNT_ID", @type="trade">, ... ]
```

Fetch a specific account:

```ruby
client.account("ACCOUNT_ID")
=> #<Kucoin::Models::Account:0x00007fb6202ecb28 @available=0.0, @balance=0.0, @currency="ETH", @holds=0.0>
```

Create a new main account for ETH:

```ruby
client.create_account(type: :main, currency: "ETH")
=> "ID_OF_NEWLY_CREATED_MAIN_ETH_ACCOUNT"
```

Create a new trading account for ETH:

```ruby
client.create_account(type: :trade, currency: "ETH")
=> "ID_OF_NEWLY_CREATED_TRADING_ETH_ACCOUNT"
```

List the ledger for a specific account:

```ruby
client.account_ledger("ACCOUNT_ID")
=> [#<Kucoin::Models::Ledger:0x00007fb6202dc520 @amount=0.0, @balance=0.0, @biz_type="Transfer", @context=nil, @created_at=2019-02-19 00:55:38 UTC, @currency="ETH", @direction=:in, @fee=0.0>,
 #<Kucoin::Models::Ledger:0x00007fb6202e6a70 @amount=0.0, @balance=0.0, @biz_type="Withdrawal", @context=nil, @created_at=2019-02-19 01:23:10 UTC, @currency="ETH", @direction=:out, @fee=0.0>, ... ]
```

#### Orders

For more advanced options (hidden, iceberg etc. etc.) see the [orders module](lib/kucoin/rest/private/orders.rb)

##### Limit orders

Create a limit buy order:

```ruby
client.create_buy_order("XRP-USDT", price: 0.10, size: 0.8)
=> "ORDER_ID_OF_NEWLY_CREATED_BUY_ORDER"
```

Create a limit sell order:

```ruby
client.create_sell_order("USDT-NUSD", price: 10, size: 0.24)
=> "ORDER_ID_OF_NEWLY_CREATED_SELL_ORDER"
```

##### Market orders

Create a market buy order:

```ruby
client.create_buy_order("VET-USDT", type: :market, size: 10)
=> "ORDER_ID_OF_NEWLY_CREATED_BUY_ORDER"
```

Create a market sell order:

```ruby
client.create_sell_order("USDT-NUSD", type: :market, size: 0.01)
=> "ORDER_ID_OF_NEWLY_CREATED_SELL_ORDER"
```

##### Cancel orders

Cancel a specific order:

```ruby
client.cancel_order("ORDER_ID_TO_CANCEL")
=> ["ID_OF_NEWLY_CANCELLED_ORDER"]
```

Cancel all orders for all pairs/symbols:

```ruby
client.cancel_all_orders
=> ["ID_OF_NEWLY_CANCELLED_ORDER", "ID_OF_ANOTHER_CANCELLED_ORDER"]
```

Cancel all orders for a specific symbol:

```ruby
client.cancel_all_orders("XRP-USDT")
=> ["ID_OF_NEWLY_CANCELLED_ORDER", "ID_OF_ANOTHER_CANCELLED_ORDER"]
```

## Status

The REST API hasn't been fully implemented yet, but nearly all endpoints are there. Transfer endpoints are still on the todo list.
Better spec coverage also needs to be implemented.
The model parsing/management will also be moved to Virtus eventually.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SebastianJ/kucoin. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kucoin project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/SebastianJ/kucoin/blob/master/CODE_OF_CONDUCT.md).
