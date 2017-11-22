//
//  IssueTrackerModel.swift
//  NetworkingRxExample
//
//  Created by Alper Akinci on 21/11/2017.
//  Copyright © 2017 Alper Akinci. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift

struct IssueTrackerModel {

    let provider: MoyaProvider<GitHub>
    let repositoryName: Observable<String> // Searched text

    func trackIssues() -> Observable<[Issue]> {
        return repositoryName
            .observeOn(MainScheduler.instance)
            .flatMapLatest({ name -> Observable<Repository?> in
                print("Name: \(name)")
                return self.findRepository(name: name)
            })
            .flatMapLatest({ (repository) -> Observable<[Issue]?> in
                guard let repository = repository else {
                    return Observable.just(nil)
                }
                print("Repository: \(repository.fullName)")
                return self.findIssues(repository: repository)
            })
            // .replaceNilWith([]) is RxOptional extension that helps us with nil, in our case we transform nil to empty array to clear table view.
            .replaceNilWith([])
    }


    func searchRepository() -> Observable<[Repository]> {
        return repositoryName
            .observeOn(MainScheduler.instance)
            .flatMapLatest({ keyword -> Observable<[Repository]?> in
                return self.searchRepository(keyword: keyword)
                })
            // - printing found repositories -
            //            .do(onNext: { (repositories) in
            //                guard let repositories = repositories else {
            //                    print("No repository found.")
            //                    return
            //                }
            //                print("Found repos : \n")
            //                for repo in repositories {
            //                    print("\(repo)\n")
            //                }
            //                print("---------- \n ")
            //            })
            .replaceNilWith([])
    }

    fileprivate func findIssues(repository: Repository) -> Observable<[Issue]?> {
        return self.provider
            .rx
            .request(GitHub.issues(repositoryFullName: repository.fullName))
            .debug() //  We use the debug() operator, which prints for us some valuable info from the request – it’s really useful in development/testing stage.
            .asObservable()
            .mapOptional(to: [Issue].self)

    }

    fileprivate func findRepository(name: String) -> Observable<Repository?> {
        return self.provider
            .rx
            .request(GitHub.repo(fullName: name))
            .debug()
            .asObservable()
            .mapOptional(to: Repository.self)
    }

    fileprivate func searchRepository(keyword: String) -> Observable<[Repository]?> {
        return self.provider
            .rx
            .request(GitHub.searchRepository(keyword: keyword))
            .debug()
            .asObservable()
            .mapOptional(to: [Repository].self, keyPath: "items")
    }
}

