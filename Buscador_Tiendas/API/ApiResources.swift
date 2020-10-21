//
//  ApiResources.swift
//  Buscador_Tiendas
//
//  Created by usuario on 20/10/2020.
//

import Foundation

let genericError = CError(moreInformation: "", httpCode: 500, httpMessage: "Error generico")

extension URLSession{

    static let clientId : String = Bundle.main.object(forInfoDictionaryKey: "clientId") as! String
    static let clientSecret : String = Bundle.main.object(forInfoDictionaryKey: "clientSecret") as! String
}

/// Tipología de llamadas
enum HttpMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// Error generico de Mi Carrefour
struct CError: Codable, Error {

    var moreInformation: String?
    var httpCode: Int?
    var httpMessage: String?
    var callID: String?
    var errorCode: Int?
    var errorDetails: String?
    var errorMessage: String?
    var apiVersion: Int?
    var statusCode: Int?
    var statusReason: String?
    var time: String?
    var errorFlags: String?
}

enum FailureReason : Error {
    case sessionFailed(error: URLError)
    case decodingFailed
    case other(Error)
    case unknown
}

struct Response<T> {
    let value: T
    let response: URLResponse
}

extension Dictionary {
    func paramsEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

// MARK: - Helper functions for creating encoders and decoders
func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

