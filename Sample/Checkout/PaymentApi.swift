//
//  PaymentApiDemo.swift
//  Sample
//
//  Created by Thomas Tong on 10/2/2021.
//

import Foundation

class PaymentApi {
    
    var payServerHost: String
    var secretKey: String
    
    init(payServerHost: String, secretKey: String) {
        self.payServerHost = payServerHost
        self.secretKey = secretKey
    }
    
    func createPayment() -> [String: Any] {
        
        /*
         * Create the Payment using Crypto.com Pay API.
         * Refer to https://pay-docs.crypto.com/ for API documentation.
         * In real world App implementation, the App should be sending a checkout to merchant server,
         * and then merchant server creates the Payment (and only server holds the Crypto.com API secret key).
         */
        let json: [String: Any] = [
            
            "return_url": AppSettings.returnUrl,
            "cancel_url": AppSettings.cancelUrl,
            
            // other sample data
            "amount": 5000, // amount in cents
            "currency": "USD",
            "description": "Crypto.com Hoodie (Unisex)",
            "order_id": "sample_order_id", // order id on merchant side, for reference
            "metadata": [ // extra info for merchant reference, can be any string
                "size": "M",
                "color": "blue",
                "customer_name": "John Doe",
                "plugin_name": "iOS App Sample"
            ]
        ]
        
        let jsonRequest = try? JSONSerialization.data(withJSONObject: json, options: [])
        
        /*
         * In real world App implementation, the App should be sending a checkout to merchant server,
         * and then merchant server creates the Payment (and only server holds the Crypto.com API secret key).
         */
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = self.payServerHost
        urlComponents.path = "/api/payments"
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.httpBody = jsonRequest
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + self.secretKey, forHTTPHeaderField: "Authorization")
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var toReturn: [String: Any] = [:]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                toReturn = ["error": ["code": error?.localizedDescription]]
                semaphore.signal()
                return
            }
            
            let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
            if let jsonResponse = jsonResponse as? [String: Any] {
                
                /*
                 * When the Payment is created, open a WebView to display the `payment_url`.
                 * Wait for the redirection to happen.
                 */
                toReturn = jsonResponse
            }
            
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        return toReturn
    }
    
    func getPayment(paymentId: String) -> [String: Any] {
        
        // Get Payment using paymentId
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = self.payServerHost
        urlComponents.path = "/api/payments/" + paymentId
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + self.secretKey, forHTTPHeaderField: "Authorization")
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var toReturn: [String: Any] = [:]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                toReturn = ["error": ["code": error?.localizedDescription]]
                semaphore.signal()
                return
            }
            
            let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
            if let jsonResponse = jsonResponse as? [String: Any] {
                toReturn = jsonResponse
            }
            
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        return toReturn
    }
}
