//
//  ApiManager.swift
//  Buscador_Tiendas
//
//  Created by usuario on 20/10/2020.
//

import SwiftUI
import Foundation
import Combine

func lanzarPeticionPublicador<T: Decodable>(url: UrlProtocol,
                                            _ decoder: JSONDecoder = newJSONDecoder(),
                                            httpMethod: HttpMethod,
                                            isAnonymus: Bool,
                                            isC4ApiRequest: Bool,
                                            mustEncodeParams: Bool,
                                            aditionalHeaders: [String:String]? = nil,
                                            params: [String : Any]? = nil) -> AnyPublisher<T, Error> {
    
    let url = url.getUrl(isAnonymus: isAnonymus)!
    
    
    return peticionPublicador(url: url,
                              httpMethod: httpMethod,
                              isAnonymus: isAnonymus,
                              isC4ApiRequest: isC4ApiRequest,
                              mustEncodeParams: mustEncodeParams,
                              aditionalHeaders: aditionalHeaders,
                              params: params)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    
    
//    if isAnonymus {
//        return peticionPublicador(url: url,
//                                  httpMethod: httpMethod,
//                                  isAnonymus: isAnonymus,
//                                  isC4ApiRequest: isC4ApiRequest,
//                                  mustEncodeParams: mustEncodeParams,
//                                  aditionalHeaders: aditionalHeaders,
//                                  params: params)
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//
//    }
//    else if let token = TokenManager.shared.getToken() {
//        return peticionPublicador(url: url,
//                                  httpMethod: httpMethod,
//                                  isAnonymus: isAnonymus,
//                                  isC4ApiRequest: isC4ApiRequest,
//                                  mustEncodeParams: mustEncodeParams,
//                                  token: token,
//                                  aditionalHeaders: aditionalHeaders,
//                                  params: params)
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    } else {
//        return TokenManager.shared.getNewTokenPublisher()!
//            .flatMap { (jwt:JWTModel) -> AnyPublisher<T, Error> in
//                return peticionPublicador(url: url,
//                                          httpMethod: httpMethod,
//                                          isAnonymus: isAnonymus,
//                                          isC4ApiRequest: isC4ApiRequest,
//                                          mustEncodeParams: mustEncodeParams,
//                                          token: jwt.idToken,
//                                          aditionalHeaders: aditionalHeaders,
//                                          params: params)
//            }.receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
}

fileprivate func peticionPublicador<T: Decodable>(url: String,
                                                  _ decoder: JSONDecoder = newJSONDecoder(),
                                                  httpMethod: HttpMethod,
                                                  isAnonymus: Bool,
                                                  isC4ApiRequest: Bool,
                                                  mustEncodeParams: Bool,
                                                  token: String = "",
                                                  aditionalHeaders: [String:String]? = nil,
                                                  params: [String : Any]?) -> AnyPublisher<T, Error> {
    
    return SESION2.dataTaskPublisher(for: URLSession.crearPeticion(url: url,
                                                                             httpMethod: httpMethod,
                                                                             isAnonymus: isAnonymus,
                                                                             isC4ApiRequest: isC4ApiRequest,
                                                                             mustEncodeParams: mustEncodeParams,
                                                                             token: token,
                                                                             aditionalHeaders: aditionalHeaders,
                                                                             params: params))
        .mapError { error -> Error in
            return error
        }
        .tryMap { result in
            
            DispatchQueue.global().async {
                let randomRequest = Int.random(in: 0 ..< 30)
                print(">\(randomRequest)> \(url)")
                print(">\(randomRequest)> \(httpMethod.rawValue)")
                print(">\(randomRequest)> \(params.debugDescription)")
                print(">\(randomRequest)> \(aditionalHeaders?.debugDescription ?? "Sin cabeceras adicionales")")
                print(">\(randomRequest)> \(String(decoding: result.data , as: UTF8.self))")
            }
            
            guard let response = result.response as? HTTPURLResponse else {
                throw genericError
            }
            do {
                if response.statusCode == 200 {
                    let value = try decoder.decode(T.self, from: result.data)
                    return value
                } else {
                    let errorValue = try decoder.decode(CError.self, from: result.data)
                    throw errorValue
                }
            }catch {//GENERAL ERROR
                let errorValue = try decoder.decode(CError.self, from: result.data)
                throw errorValue
            }
        }
        .eraseToAnyPublisher()
    
}

let SESION2: URLSession = URLSession(configuration: URLSessionConfiguration.default)


//MARK: Parte antigua
extension URLSession{
    
    /// Creacion de la url con los headers y los parametros
    /// - Parameters:
    ///   - url: valor del enumerado
    ///   - httpMethod: HttpMethod(GET,POST,...)
    ///   - isAnonymus: si el usuario es anonimo
    ///   - isC4ApiRequest: se identifica solo para las llamadas de carrefour con el clientID y clientSecret del api
    ///   - params: parametros para el body si los hubiera
    static func crearPeticion(url: String,
                              httpMethod: HttpMethod,
                              isAnonymus: Bool,
                              isC4ApiRequest: Bool,
                              mustEncodeParams: Bool,
                              token: String = "",
                              aditionalHeaders: [String:String]? = nil,
                              params: [String:Any]? = nil) -> URLRequest{
        
        let urlComponents = NSURLComponents(string: url)!
        
        if httpMethod == .get || httpMethod == .delete, let params = params{//parametros para GET
            var getQueryParams = [URLQueryItem]()
            
            params.forEach({parameter in
                if let paramValue = parameter.value as? String{
                    getQueryParams.append(URLQueryItem(name: parameter.key, value: paramValue))
                }
            })
            urlComponents.queryItems = getQueryParams
        }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = httpMethod.rawValue
        
        //Cabecera genérica de la App Mi Carrefour
        urlRequest.setValue("FeedFetcher", forHTTPHeaderField: "ClientType")
        urlRequest.setValue("890", forHTTPHeaderField: "ClientID")
        urlRequest.setValue("MiCarrefour3.0 DeviceID: 48759E41-2CBE-40AF-9AFD-241BB0A03B45", forHTTPHeaderField: "User-Agent")
        
        if isC4ApiRequest {
            
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
            urlRequest.setValue(URLSession.clientSecret, forHTTPHeaderField: "x-ibm-client-id")
            urlRequest.setValue(URLSession.clientId, forHTTPHeaderField: "x-ibm-client-secret")
            
//            let foodCookieValue = Session.shared.getCookieFromPersistance(CookieType.foodCookie)?.value
//            let nonFoodCookieValue = Session.shared.getCookieFromPersistance(CookieType.nonFoodCookie)?.value
//            if let foodCookie = foodCookieValue {
//                urlRequest.setValue(foodCookie, forHTTPHeaderField: CookieType.foodCookie.getCookieName())
//            }
//
//            if let nonFoodcookieValue = nonFoodCookieValue {
//                urlRequest.setValue(nonFoodcookieValue, forHTTPHeaderField: CookieType.nonFoodCookie.getCookieName())
//            }
            
            if let aditionalHeaders = aditionalHeaders{
                aditionalHeaders.forEach { (header,value) in
                    urlRequest.setValue(value, forHTTPHeaderField: header)
                }
            }
        }
        
//        if !isAnonymus{
//            urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")//token obtained from jwt todo
//        }
        
        if httpMethod != .get { //parametros en body
            if let parametros = params{
                
                if mustEncodeParams {
                    urlRequest.httpBody = parametros.paramsEncoded()
                } else {
                    do {
                        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parametros, options: [])
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
        
        return urlRequest
    }
}

