//
//  ViewController.swift
//  NetworkingRxExample
//
//  Created by Alper Akinci on 13/11/2017.
//  Copyright © 2017 Alper Akinci. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya

/**

 What is this controller do?

 - It should get the data from search bar, pass it to model, get issues from model and pass it to table view.

*/
class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    let disposeBag = DisposeBag()
    var provider: MoyaProvider<GitHub>!
    var issueTrackerModel: IssueTrackerModel!
    var latestRepositoryName: Observable<String> {
        return searchBar
            .rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx() // Bindings
    }

    func setupRx() {
        // First part of the puzzle, create our Provider
        provider = MoyaProvider<GitHub>()

        // Setup Model
        issueTrackerModel = IssueTrackerModel(provider: provider, repositoryName: latestRepositoryName)

        // Find issues on searched repo
//        issueTrackerModel
//            .trackIssues()
//            .do(onNext: { (issues) in
//                for i in issues {
//                    print( "\(i.title)\n")
//                }
//            })
//            .bind(to: tableView.rx.items){ tableView, row, item in
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: IndexPath(row: row, section: 0))
//                cell.textLabel?.text = item.title
//
//                return cell
//        }.disposed(by: disposeBag)

        // Search repo name
        issueTrackerModel
            .searchRepository()
            .do(onError: { (error) in
                print(error.localizedDescription)
            })
            .bind(to: tableView.rx.items){ tableView, row, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: IndexPath(row: row, section: 0))
                cell.textLabel?.text = item.fullName

                return cell
            }.disposed(by: disposeBag)

        // Here we tell table view that if user clicks on a cell,
        // and the keyboard is still visible, hide it
        // (which emits signal every time someone taps on table view cell)
        tableView
            .rx.itemSelected
            .subscribe(onNext: { indexPath in
                if self.searchBar.isFirstResponder == true {
                    self.view.endEditing(true)
                }
            })
            .disposed(by: disposeBag)
    }

}

