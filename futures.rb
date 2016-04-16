module Okcoin

 CONTRACTS = {this_week: true, next_week: true, quarter: true}

 require "net/http"
 require "uri"
 require "json"

 def contract_parser( contract )
  tocall = "https://www.okcoin.com/api/v1/future_ticker.do?symbol=btc_usd&contract_type=" + contract.to_s
  return tocall
 end

 def contract_response( tocall, contract )

  puts "Calling #{ tocall }"

  uri = URI.parse( tocall )
  response = Net::HTTP.get_response(uri)
  data = JSON.parse(response.body)

buy = ""
sell = ""
hi = ""
low = ""
vol = ""

  data.each do |item|
   item.each do |v|
	buy =  v["buy"].to_s
	sell = v["sell"].to_s
	hi = v["high"].to_s
 	low = v["low"].to_s
	vol = v["vol"].to_s

   end
  end

contract = contract.to_s

heading = '<body style="color:white;font-family:Droid Sans;"><p><b>OkCoin Futures ' + contract + ':</b></p>'
prices = '<p>Buy: ' + buy + '</p><p>Sell: ' + sell + '</p><p>Low: ' + low + '</p><p>Hi: ' + hi + '</p>'
volume = '<p>Vol: ' + vol + '</p></body>'

content = heading.to_s + prices.to_s + volume.to_s

puts content


  if contract.include? "this"
        file = File.open( "/var/lib/openshift/571212152d5271ceef000126/app-root/repo/public/thisweek.html", "w+")
        file.write(content)
        file.close
  elsif contract.include? "next"
        file = File.open( "/var/lib/openshift/571212152d5271ceef000126/app-root/repo/public/nextweek.html", "w+")
        file.write(content)
        file.close
  elsif contract.include? "quarter"
        file = File.open( "/var/lib/openshift/571212152d5271ceef000126/app-root/repo/public/quarter.html", "w+")
        file.write(content)
        file.close
  end#inner if

 end#response
end#module
