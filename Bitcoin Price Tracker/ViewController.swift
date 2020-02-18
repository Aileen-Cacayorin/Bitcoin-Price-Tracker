//
//  ViewController.swift
//  Bitcoin Price Tracker
//
//  Created by Aileen Bull on 2/14/20.
//  Copyright © 2020 Aileen Bull. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var jpnLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDefaultPrice()
        getPrice()
    }
    
    func getPrice() {
        if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,JPY,EUR") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    if let json =  try? JSONSerialization.jsonObject(with: data, options: []) as? [ String:Double] {
                        if let jsonDictionary = json {
                            DispatchQueue.main.async {
                                if let usdPrice = jsonDictionary["USD"] {
                                    self.usdLabel.text = self.doubleToMoneyString(price:usdPrice,currencyCode:"USD")
                                    self.setDefaultPrice(price:usdPrice,currencyCode:"USD")
                                }
                                
                                if let eurPrice = jsonDictionary["EUR"] {
                                    self.eurLabel.text = self.doubleToMoneyString(price:eurPrice,currencyCode: "EUR")
                                    self.setDefaultPrice(price:eurPrice,currencyCode:"EUR")
                                }
                                if let jpnPrice = jsonDictionary["JPY"] {
                                    self.jpnLabel.text = self.doubleToMoneyString(price: jpnPrice,currencyCode: "JPY")
                                    self.setDefaultPrice(price:jpnPrice,currencyCode:"JPY")
                                }
                            }
                        }
                    }
                } else {
                    print("nope")
                }
            }.resume()
        }
    }

    func doubleToMoneyString(price:Double,currencyCode:String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        let priceString =  formatter.string(from: NSNumber(value: price))
        if priceString == nil {
            return "SOMETHING WENT WRONG"
        } else {
             return priceString!
        }
    }
    
    func setDefaultPrice(price:Double,currencyCode:String) {
        UserDefaults.standard.set(price, forKey: currencyCode)
        UserDefaults.standard.synchronize()
        print(price)
    }
    
    func getDefaultPrice() {
        let usdPrice = UserDefaults.standard.double(forKey: "USD")
        let eurPrice = UserDefaults.standard.double(forKey: "EUR")
        let jpnPrice = UserDefaults.standard.double(forKey: "JPN")
        
        if usdPrice != 0.0 {
            self.usdLabel.text = self.doubleToMoneyString(price:usdPrice,currencyCode:"USD") + "~"
        }
        if eurPrice != 0.0 {
            self.eurLabel.text = self.doubleToMoneyString(price:eurPrice,currencyCode: "EUR") + "~"
        }
        
        if jpnPrice != 0.0 {
            self.jpnLabel.text = self.doubleToMoneyString(price: jpnPrice,currencyCode: "JPY") + "~"
        }
    }
}

