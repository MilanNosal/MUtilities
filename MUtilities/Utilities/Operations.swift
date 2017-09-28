//
//  Operations.swift
//  MUtilities
//
//  Created by Milan Nosáľ on 28/09/2017.
//  Copyright © 2017 Svagant. All rights reserved.
//

import Foundation

public func download(from urlString: String?) -> (data: Data?, response: URLResponse?, error: Error?) {
    if let urlString = urlString,
        let url = URL(string: urlString) {
        let request = URLRequest(url: url)
        if let urlResponse = URLCache.shared.cachedResponse(for: request) {
            return (data: urlResponse.data, response: nil, error: nil)
        } else {
            return URLSession.shared.synchronousDataTask(with: request)
        }
    } else {
        return (data: nil, response: nil, error: nil)
    }
}

public extension URLSession {
    public func synchronousDataTask(with urlRequest: URLRequest) -> (data: Data?, response: URLResponse?, error: Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        dataTask(with: urlRequest) {
            data = $0; response = $1; error = $2
            semaphore.signal()
            }.resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return (data: data, response: response, error: error)
    }
}


public func download(from urlString: String?, using queue: OperationQueue = DataDownloadOperation.defaultDownloadQueue, completionCallback: @escaping (Data) -> Void) -> DataDownloadOperation? {
    
    if let urlString = urlString,
        let url = URL(string: urlString) {
        let request = URLRequest(url: url)
        if let urlResponse = URLCache.shared.cachedResponse(for: request) {
            completionCallback(urlResponse.data)
        } else {
            let downloadOperation = DataDownloadOperation(from: request) {
                (data) -> Void in
                completionCallback(data)
            }
            queue.addOperation(downloadOperation)
            return downloadOperation
        }
    }
    return nil
}

public func downloadItunes(from urlString: String?, using queue: OperationQueue = DataDownloadOperation.defaultDownloadQueue, completionCallback: @escaping (Data) -> Void) -> DataDownloadOperation? {
    
    if let urlString = urlString,
        let url = URL(string: urlString) {
        
        let request = URLRequest(url: url)
        if let urlResponse = URLCache.shared.cachedResponse(for: request) {
            completionCallback(urlResponse.data)
        } else {
            let downloadOperation = DataDownloadOperation(from: request) {
                (data) -> Void in
                
                completionCallback(data)
            }
            queue.addOperation(downloadOperation)
            return downloadOperation
        }
    }
    return nil
}

open class DataDownloadOperation: Operation {
    
    open static let defaultDownloadQueue: OperationQueue = {
        let queue: OperationQueue = OperationQueue()
        queue.name = "Default download queue"
        return queue
    }()
    
    private var workingIsCancelled: Bool = false
    
    let completionCallback: (Data) -> Void
    let urlRequest: URLRequest
    
    init(from urlRequest: URLRequest, completionCallback: @escaping (Data) -> Void) {
        self.completionCallback = completionCallback
        self.urlRequest = urlRequest
    }
    
    open override func cancel() {
        super.cancel()
        self.workingIsCancelled = true
    }
    
    open override func main() {
        if let response = URLCache.shared.cachedResponse(for: urlRequest) {
            DispatchQueue.main.async() { () -> Void in
                if self.workingIsCancelled {
                    return
                }
                self.completionCallback(response.data)
            }
        } else {
            URLSession.shared.dataTask(with: urlRequest) {
                (data, response, error) in
                if self.workingIsCancelled {
                    return
                }
                guard let data = data, error == nil else {
                    print("\(String(describing: error))")
                    self.cancel()
                    return
                }
                if self.workingIsCancelled {
                    return
                }
                DispatchQueue.main.async {
                    if self.workingIsCancelled {
                        return
                    }
                    self.completionCallback(data)
                }
            }.resume()
        }
    }
}

