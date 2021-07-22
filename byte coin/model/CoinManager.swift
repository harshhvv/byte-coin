//
//  CoinManager.swift
//  byte coin
//
//  Created by Harsh  on 22/07/21.
//

import Foundation

//protocol to pass data
protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "YOUR_API_KEY_HERE"
    
    
    var delegate:CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func getCoinPrice(for currency: String) {
            
            let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"

            if let url = URL(string: urlString) {
                
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    
                    if let safeData = data {
                        
                        if let bitcoinPrice = self.parseJSON(safeData) {
                            
                            //Optional: round the price down to 2 decimal places.
                            let priceString = String(format: "%.2f", bitcoinPrice)
                            
                            //Call the delegate method in the delegate (ViewController) and
                            //pass along the necessary data.
                            self.delegate?.didUpdatePrice(self, price: priceString, currency: currency)
                        }
                    }
                }
                task.resume()
            }
        }
    
    func parseJSON(_ data:Data) -> Double?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastprice = decodedData.rate
            print(lastprice)
            return lastprice
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
