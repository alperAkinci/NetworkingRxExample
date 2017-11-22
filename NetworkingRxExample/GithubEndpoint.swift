//
//  GithubEndpoint.swift
//  NetworkingRxExample
//
//  Created by Alper Akinci on 14/11/2017.
//  Copyright © 2017 Alper Akinci. All rights reserved.
//

import Foundation
import Moya

/**
 MOYA SETUP

 1 ) Provider

 2 ) Endpoint

 */

// ** MOYA Endpoint Implemantation **

enum GitHub {
    case userProfile(username: String)
    case repos(username: String)
    case repo(fullName: String)
    case issues(repositoryFullName: String)
    case searchRepository(keyword: String)
}

extension GitHub: TargetType {

    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }

    var path: String {
        switch self {
        case .repos(let name):
            return "/users/\(name.URLEscapedString)/repos"
        case .userProfile(let name):
            return "/users/\(name.URLEscapedString)"
        case .repo(let name):
            return "/repos/\(name)"
        case .issues(let repositoryName):
            return "/repos/\(repositoryName)/issues"
        case .searchRepository:
            return "/search/repositories"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        switch self {
        case .repos(_):
            return "{{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}}}".data(using: .utf8)!
        case .userProfile(let name):
            return "{\"login\": \"\(name)\", \"id\": 100}".data(using: .utf8)!
        case .repo(_):
            return "{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}".data(using: .utf8)!
        case .issues(_):
            return "{\"id\": 132942471, \"number\": 405, \"title\": \"Updates example with fix to String extension by changing to Optional\", \"body\": \"Fix it pls.\"}".data(using: .utf8)!
        case .searchRepository:
            return "{}".data(using: .utf8)!
        }
    }

    var task: Task {
        switch self {
        case .searchRepository(let keyword):
            return .requestParameters(parameters: ["q" : keyword], encoding: URLEncoding.default)
        default:
             return .requestPlain
        }

    }

    var headers: [String : String]? {
        return nil
    }

}
