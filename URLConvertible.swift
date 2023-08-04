//
//  URLConvertible.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 03.08.2023.
//

import Foundation

public enum HTTPMethod: String {
  case options = "OPTIONS"
  case get = "GET"
  case head = "HEAD"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
  case trace = "TRACE"
  case connect = "CONNECT"
}

// URL contains path components in order corePath, apiVersion, path and optionally query parameters
public protocol URLRequestConvertible {
  var baseURL: URL { get }
  var url: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String] { get }

  // Returns a URL request or throws if an `Error` was encountered.
  //
  // - throws: An `Error` if the underlying `URLRequest` is `nil`.
  //
  // - returns: A URL request.
  func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertible {
  // The URL request.
  var urlRequest: URLRequest? { try? asURLRequest() }
}

// MARK: - Default Values
public extension URLRequestConvertible {
  var baseURL: URL {
    guard let url = URL(string: "https://api.spacexdata.com" ) else {
      fatalError("BaseURL could not be configured.")
    }
    return url
  }
  var url: URL {
    baseURL
      .appendingPathComponent(path)
  }
}

// MARK: - Helper Methods
public extension URLRequestConvertible {
  // Adapting URLRequest with predefined HTTPHeaderFields.
  // Should be called anytime you want to create URLRequest.
  func adaptURLRequest() throws -> URLRequest {
  var urlRequest = URLRequest(url: url)

    urlRequest.httpMethod = method.rawValue

    headers.forEach {
      urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
    }

    return urlRequest
  }
}

enum LaunchesRequest: URLRequestConvertible {
  case launches(LaunchesParameters)

  var method: HTTPMethod {
    switch self {
    case .launches:
      return .post
    }
  }

  var path: String {
    switch self {
    case .launches:
      return "/v4/launches/query"
    }
  }

  var headers: [String: String] {
    switch self {
    case .launches:
      return ["Content-Type": "application/json"]
    }
  }

  func asURLRequest() throws -> URLRequest {
    var urlRequest = try adaptURLRequest()

    switch self {
    case .launches(let parameters):
      try urlRequest.add(parameters)
      return urlRequest
    }
  }
}

public extension URLRequest {
  // Adding Parameters (as JSON Object) to the URLRequest body
  // - Parameter parameters: Encodable Parameters to be added
  // - Throws: An Error during Encoding or JSON serialization
  mutating func add<T: Encodable>(_ parameters: T) throws {
    let encoder = JSONEncoder()
    let encoded = try encoder.encode(parameters)
    let json = try JSONSerialization.jsonObject(with: encoded)
    let data = try JSONSerialization.data(withJSONObject: json)
    httpBody = data
  }
}


struct LaunchesParameters: Encodable {
  let options: Option
  let query: Query
}

struct Query: Codable {
  let name: Parameters
}

struct Parameters: Codable {
  let regex: String
  let options: String
  enum CodingKeys: String, CodingKey {
    case regex = "$regex"
    case options = "$options"
  }
}

struct Option: Codable {
  let limit: Int
  let page: Int
  let select: [String]
  let sort: [String: String]
}
