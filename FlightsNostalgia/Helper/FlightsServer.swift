//
//  FlightsServer.swift
//  FlightsNostalgia
//
//  Created by hyperactive on 02/02/2021.
//

import Foundation

class FlightsServer: NSObject, URLSessionDelegate {
    
    static let shared = FlightsServer()
    let mainURL = "http://10.0.0.16:5000/"
    
    private override init() {}
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    func post(req: ServerPostRequests, info: [[String : Any]], completion: @escaping (_ data: Data?) -> Void) {
        
        // MARK: - refactor to send completion with failure handler
    
        guard let url = URL(string: mainURL + req.rawValue) else { return }
        guard let request = makeRequest(with: url, body: info) else { return }
        
        URLSession.shared.dataTask(with: request) { (data, res, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            completion(data)
            
        }.resume()
    }
    
    func makeRequest(with url: URL, body: [[String: Any]]) -> URLRequest? {
        
        guard let body = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 300
        
        return request
    }
}
