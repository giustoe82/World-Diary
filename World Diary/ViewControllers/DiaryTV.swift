//
//  DiaryTV.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-01-31.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit

//Entry cells
class EntryCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var thumbImage: UIImageView!
}

//Loading Cell content
struct FakeEntry {
    var id = ""
    var imgUrl = ""
    var img: UIImage?
    var thumbUrl = ""
    var thumb = UIImage(named: "loading")
    var comment = "Loading ..."
    var date = ""
    var time = ""
    var lat = 0.0
    var lon = 0.0
    var address = ""
    var uID = ""
    var dayLiteral = ""
}

//TableView Diary
class DiaryTV: UITableViewController, DataDelegate {
    
    var presenter: DiaryTVProtocol?
    var dataManager = DBManager()
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    var arrayTest: [Entry] = []
    var isSearching: Bool = false
    var entryToDisplay: Entry?
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.dataDel = self
        searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataManager.EntriesArray.removeAll()
        dataManager.loadDataBase()
        
    }
    
    func reload() {
        tableView.layoutSubviews()
        tableView.reloadData()
        
    }
   
// MARK: - TableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataManager.EntriesArray.isEmpty {
            return 1
        }else if isSearching == false {
            print(dataManager.EntriesArray)
            return dataManager.EntriesArray.count
        } else {
            print("search \(dataManager.filteredEntries.count)")
            return dataManager.filteredEntries.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! EntryCell
        let row = indexPath.row
        tableView.rowHeight = 160
      
        if dataManager.EntriesArray.isEmpty {
            let entryCell = FakeEntry()
            cell.dateLabel?.text = entryCell.date
            cell.timeLabel?.text = entryCell.time
            cell.commentLabel?.text = entryCell.comment
            cell.addressLabel?.text = entryCell.address
            cell.thumbImage?.image = entryCell.thumb
        } else if isSearching == false  {
            let entryCell = dataManager.EntriesArray[row]
            cell.dateLabel?.text = entryCell.date
            cell.timeLabel?.text = entryCell.time
            cell.commentLabel?.text = entryCell.comment
            cell.addressLabel?.text = entryCell.address
            cell.thumbImage?.image = entryCell.thumb
        } else {
            let entryCell = dataManager.filteredEntries[row]
            cell.dateLabel?.text = entryCell.date
            cell.timeLabel?.text = entryCell.time
            cell.commentLabel?.text = entryCell.comment
            cell.addressLabel?.text = entryCell.address
            cell.thumbImage?.image = entryCell.thumb
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching == false {
            presenter?.goToSingleView(entry: dataManager.EntriesArray[indexPath.row], index: indexPath.row)
        } else {
            presenter?.goToSingleView(entry: dataManager.filteredEntries[indexPath.row], index: indexPath.row)
        }
    }
    
    //Delete Post
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            dataManager.deleteImage(position: indexPath.row)
            dataManager.deleteThumb(position: indexPath.row)
            dataManager.deleteFromDB(position: indexPath.row)
            dataManager.EntriesArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}

// MARK: - SearchBar

extension DiaryTV: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            dataManager.filteredEntries = dataManager.EntriesArray.filter { $0.comment.localizedCaseInsensitiveContains( searchText ) ||
                $0.date.localizedCaseInsensitiveContains( searchText ) ||
                $0.address.localizedCaseInsensitiveContains( searchText )
            }
            tableView.reloadData()
        }
    }
    
    //Functions to regulate keyboard behaviour during search
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}


