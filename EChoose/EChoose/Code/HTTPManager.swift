//
//  HTTPManager.swift
//  EChoose
//
//  Created by Oparin Oleg on 14.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//
import Foundation

class HTTPManager {
    
    //MARK: - GET Request
    func loadDataGET(url: URL, withSerializer serializer: ((Any) -> Bool)?) {
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            guard let response = response, let data = data else { return }
            print("Response: \(response)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let result = serializer!(json)
                print("Serialization success: \(result)")
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    //MARK: - POST Request
    func loadDataPOST(url: URL, data: Any, withSerializer serializer: ((Any) -> Bool)?) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: data, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            guard let response = response, let data = data else { return }
            print("Response: \(response)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let result = serializer!(json)
                print("Serialization success: \(result)")
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
//MARK: - Serializers
extension HTTPManager {
    
}
