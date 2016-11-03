//
//  PurchaseListViewController.swift
//  PurchaseList
//
//  Created by Cesar Brenes on 10/28/16.
//  Copyright (c) 2016 Cesar Brenes. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol PurchaseListViewControllerInput{
   func displayFetchedItems(viewModel:PurchaseList.FetchItems.ViewModel)
   func displayDeleteResultSuccessful(viewModel: PurchaseList.Delete.ViewModel.Successful)
   func displayDeleteResultError(viewModel: PurchaseList.Delete.ViewModel.Error)
}

protocol PurchaseListViewControllerOutput{
     func fetchItems(request:PurchaseList.FetchItems.Request)
     func requestDeleteItem(request: PurchaseList.Delete.Request)
}

class PurchaseListViewController: UIViewController, PurchaseListViewControllerInput, UITableViewDelegate, UITableViewDataSource{
    var output: PurchaseListViewControllerOutput!
    var router: PurchaseListRouter!
    
    var displayedItems: [PurchaseList.FetchItems.ViewModel.DisplayedItem] = []
    
    // MARK: UI OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Object lifecycle
    
    override func awakeFromNib(){
        super.awakeFromNib()
        PurchaseListConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        title = "Purchase List"
        fetchItems()
    }
    
    // MARK: Event handling
    
    func fetchItems(){
        // NOTE: Ask the Interactor to do some work
        let request = PurchaseList.FetchItems.Request()
        output.fetchItems(request: request)
    }
    
    // MARK: Display logic
    
    func displayFetchedItems(viewModel:PurchaseList.FetchItems.ViewModel){
        displayedItems = viewModel.displayedItems
        tableView.reloadData()
    }
    
    func displayDeleteResultSuccessful(viewModel: PurchaseList.Delete.ViewModel.Successful){
        tableView.beginUpdates()
        displayedItems.remove(at: viewModel.indexPath.row)
        tableView.deleteRows(at: [viewModel.indexPath], with: .fade)
        tableView.endUpdates()
    }
    
    func displayDeleteResultError(viewModel: PurchaseList.Delete.ViewModel.Error){
        present(viewModel.alertController, animated: true)
    }
    
    // MARK: TABLE VIEW METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = displayedItems[indexPath.row].name
        cell?.detailTextLabel?.text = displayedItems[indexPath.row].quantity
        return cell!
    }
    
 
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
     }
 
    
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
          deleteItem(atIndex: indexPath.row)
        }
     }
    
    
    // MARK: OTHERS METHODS
    func deleteItem(atIndex: Int){
        let request = PurchaseList.Delete.Request(index: atIndex)
        output.requestDeleteItem(request: request)
    }
    
    
    // MARK: ACTIONS
    @IBAction func addItemAction(_ sender: Any) {
        router.goToAddItemViewController()
    }
    
    
    
    
}