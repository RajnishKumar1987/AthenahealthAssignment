//
//  NetworkManager.swift
//  SampleApp
//
//  Created by Rajnish kumar on 13/08/18.
//  Copyright © 2018 Rajnish kumar. All rights reserved.
//

import Foundation
import UIKit

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

public struct NetworkError: Codable{
    public var statusCode: Int?
    public var errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "code"
        case errorMessage = "message"
    }
}

public enum Result<NetworkError> {
    case success
    case failure(NetworkError)
}

public typealias HTTPHeaders = [String:String]

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol APIRequest {
    
    associatedtype RequestDataType
    associatedtype ResponseDataType

    func makeRequest(requestType: HTTPMethod, function:ApiEndPoint, parameters: RequestDataType, requestHeaders: HTTPHeaders? ) throws -> URLRequest
    func parseResponse(data: Data) throws -> ResponseDataType
    func shouldCacheResponse() -> Bool
    
}

extension APIRequest {
        
    func shouldCacheResponse() -> Bool {
        return false
    }
   
    func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        
        for (key, value) in headers{
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
}

class APIRequestLoader<T: APIRequest> {
    
    let apiRequest: T
    let urlSession: URLSession
    var task: URLSessionDataTask?
    
    init(apiRequest: T, urlSession: URLSession = .shared) {
        self.apiRequest = apiRequest
        self.urlSession = urlSession
    }
    
    deinit {
        print("deinit : \(apiRequest) ")
    }
    
    func loadAPIRequest(request: HTTPMethod,  funcion:ApiEndPoint, requestData: T.RequestDataType, requestHeaders: HTTPHeaders?, completionHandler: @escaping(T.ResponseDataType?, NetworkError?)-> Void) {
        
        do {
            
            let urlRequest = try self.apiRequest.makeRequest(requestType: request, function: funcion, parameters: requestData, requestHeaders: requestHeaders)
            
            if AppConfig.isDebugLogEnable {
                NetworkLogger.log(request: urlRequest)
            }

        
            task = urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                
                if AppConfig.isDebugLogEnable {
                    NetworkLogger.log(response: response, data: data, error: error, forRequest: urlRequest)
                }
                if let error = error{
                    DispatchQueue.main.async {
                        completionHandler(nil, NetworkError(statusCode: error.code, errorMessage: error.localizedDescription))
                    }
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response, data: data)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            DispatchQueue.main.async {
                                completionHandler(nil, NetworkError(statusCode: 200, errorMessage: "No data"))
                            }
                            return
                        }
                        do {
                            let parsedResponse = try self.apiRequest.parseResponse(data: responseData)
                            DispatchQueue.main.async {
                                completionHandler(parsedResponse,nil)
                            }
                        }catch {
                            print(error)
                            DispatchQueue.main.async {
                                completionHandler(nil, NetworkError(statusCode: 200, errorMessage: "We could not decode the response."))
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completionHandler(nil, error)
                        }
                    }
                }
                
              
            })
            
            task?.resume()
        } catch  {
            print("Unable to create request")
        }
        
    }
    
    func cancelTask()
    {
        self.task?.cancel()
        self.task = nil
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse, data: Data?) -> Result<NetworkError>{
        
        var error = NetworkError(statusCode: response.statusCode, errorMessage: "Network request failed.")
        print(response.statusCode)
        switch response.statusCode {
        case 200...299: return .success
        case 400...600:
            do{
                error = try JSONDecoder().decode(NetworkError.self, from: data!)
            }catch{}
            return .failure(error)
        default:
            return .failure(error)
        }
    }
    
}


let dataCache = NSCache<NSString, NSData>()

extension APIRequestLoader{
    
    func getCachedData(from request: URLRequest) -> T.ResponseDataType? {
        
        if let key = request.url?.absoluteString, let cachedData = dataCache.object(forKey: key as NSString) {

            return try? self.apiRequest.parseResponse(data: cachedData as Data)
        }
        return nil
    }
    
    func cacheData(data: Data, forRequest: URLRequest?) {
        if let key = forRequest?.url?.absoluteString {
            dataCache.setObject(data as NSData, forKey: key as NSString)
        }
    }
}








