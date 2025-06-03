//
//  SignUpRequest.swift
//  FakeShop
//
//  Created by 이태형 on 1/16/25.
//

import UIKit
import Alamofire

class AuthRequest{
    static func signUp(_ data: [String], completion: @escaping (Result<SignUpRes,Error>)->Void){
        guard data.count == 7 else{return}
        var request = URLRequest(url: URL.signUpUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        let nameParam: [String:String] = ["firstname" : data[2], "lastname" : data[3]]
        let geoParam: [String:String] = ["lat":"-37", "long":"81"]
        let addressParam: [String:Any] = ["city":"kilcoole",
                                          "street":data[5],
                                          "number":3,
                                          "zipcode":"12926-3874",
                                          "geolocation":geoParam
        ]
        let params: [String:Any] = [ "username" : data[0],
                                    "password" : data[1],
                                    "name" : nameParam,
                                    "email" : data[4],
                                    "address" : addressParam,
                                    "phone" : data[6],
        ] as Dictionary
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error:", #function)
        }
        
        AF.request(request).responseDecodable(of: SignUpRes.self){res in
            switch res.result{
            case .success(let data):
                completion(.success(data))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    static func logIn(_ id: String, _ pw: String, completion: @escaping (Result<UserToken,Error>)->Void){
        var request = URLRequest(url: URL.logInUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        var params: [String:String] = [:]
#if DEBUG
        params = ["username": "mor_2314", "password": "83r5^_"]
#else
        params = ["username": id, "password": pw]
#endif
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error:", #function)
        }
        
        AF.request(request).responseDecodable(of: UserToken.self){res in
            print(res.response?.statusCode) //401: wrong params (When Wrong userAccount)
            switch res.result{
            case .success(let data):
                completion(.success(data))
            case .failure(let err):
                completion(.failure(err))
            }
        }
        
    }
    
}

//MARK: - RxSwift
import RxSwift

class AuthRequestRx{
    
    func signUp(id: String, pw: String, firstName: String, lastName: String, email: String, address: String, phone: String) -> Observable<SignUpRes>{
        let nameParam: [String:String] = ["firstname" : firstName, "lastname" : lastName]
        let geoParam: [String:String] = ["lat":"-37", "long":"81"]
        let addressParam: [String:Any] = ["city":"kilcoole",
                                          "street": address,
                                          "number":3,
                                          "zipcode":"12926-3874",
                                          "geolocation":geoParam
        ]
        let params: [String:Any] = [ "username" : id,
                                     "password" : pw,
                                     "name" : nameParam,
                                     "email" : email,
                                     "address" : addressParam,
                                     "phone" : phone
        ] as Dictionary
        
        return Observable.create { observer in
            AF.request(URL.signUpUrl, method: .post, parameters: params, encoding: JSONEncoding.default)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: SignUpRes.self) { res in
                    switch res.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    func loginNative(id: String, pw: String) -> Observable<UserToken>{
        var params: [String:String] = [:]
#if DEBUG
        params = ["username": "mor_2314", "password": "83r5^_"]
#else
        params = ["username": id, "password": pw]
#endif
        
        return Observable.create { observer in
            AF.request(URL.logInUrl, method: .post, parameters: params, encoding: JSONEncoding.default)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: UserToken.self) { res in
                    switch res.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    //MARK: SignUp Mock
    func signUpMock(id: String, pw: String, firstName: String, lastName: String, email: String, address: String, phone: String) -> Observable<SignUpRes>{
        var isSuccess: Bool = true
        var errorType: SignUpErrorMock = .emailAlreadyExists
        
        if isSuccess{
            let response: SignUpRes = SignUpRes(id: 0000, username: "id", password: "pw", email: "email", phone: "000-0000-0000", name: SignUpRes.NameEn(firstname: "F", lastname: "L"), address: SignUpRes.AddressEn(city: "city", street: "street", zipcode: "zipcode", number: 0, geolocation: SignUpRes.AddressEn.GeolocationEn(lat: "127", long: "36")))
            return Observable.just(response).delay(.milliseconds(500), scheduler: MainScheduler.instance)
        } else {
            return Observable<SignUpRes>.error(errorType).delay(.milliseconds(500), scheduler: MainScheduler.instance)
        }
    }
    enum SignUpErrorMock: Error, LocalizedError {
        case emailAlreadyExists
        case unknown

        var errorDescription: String? {
            switch self {
            case .emailAlreadyExists:
                return "이미 존재하는 이메일입니다."
            case .unknown:
                return "알 수 없는 오류가 발생했습니다."
            }
        }
    }
}
