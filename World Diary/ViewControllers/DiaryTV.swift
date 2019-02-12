//
//  DiaryTV.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-01-31.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit



//Cell of the day
class DaySectionCell: UITableViewCell {
    @IBOutlet weak var dayTitleLabel: UILabel!
    @IBOutlet weak var openCloseArrow: UIImageView!
    
}

//Entry cells
class EntryCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var thumbImage: UIImageView!
    
    
}

//TableView Diary
class DiaryTV: UITableViewController {
    
    
    
    
//    var myArray: [Entry] = []
//    var days: [Day]?
//    var newDay: Day?
    var presenter: DiaryTVProtocol?
    
    //Entry data
    var tableViewData: [Day] = [] { didSet{
        tableView.reloadData()
        }}

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tableViewData = (presenter?.prepareArray())!
    }
    override func viewDidAppear(_ animated: Bool) {
        //tableView.reloadData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableViewData.removeAll()
    }
        
        
        //let day = Day(opened: false, date: "February 1 Friday", sectionData: [entry00, entry00])
        
//        tableViewData = [
//            Day(opened: false, date: "February 1 Friday", sectionData: [entry00, entry00]),
//                         Day(opened: false, date: "January 30 Wednesday", sectionData: [entry00]),
//                         Day(opened: false, date: "January 29 Tuesday", sectionData: [entry00, entry00]),
//                         Day(opened: false, date: "January 27 Sunday", sectionData: [entry00, entry00, entry00])
//        ]
       
    
    
    // MARK: - Functions
  

    // MARK: - Table view data source
    //Entries are grouped by day. Each day is an expandable cell with subcells for entries
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (tableViewData.count)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return (tableViewData[section].sectionData?.count)! + 1
        } else {
           return 1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            //section title should be the date
            let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell") as! DaySectionCell
            cell.dayTitleLabel?.text = tableViewData[indexPath.section].date
            //arrow up or down
            if tableViewData[indexPath.section].opened == true {
                cell.openCloseArrow.image = UIImage(named: "up-arrow")
            } else {
                cell.openCloseArrow.image = UIImage(named: "down-arrow")
            }
            return cell
        } else {
            // cell for the entries
            let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell") as! EntryCell
            cell.timeLabel.text = tableViewData[indexPath.section].sectionData?[indexPath.row - 1].dayTime
            cell.addressLabel.text = tableViewData[indexPath.section].sectionData?[indexPath.row - 1].address
            cell.commentLabel.text = tableViewData[indexPath.section].sectionData?[indexPath.row - 1].myText
            cell.thumbImage.image = UIImage(named: (tableViewData[indexPath.section].sectionData?[indexPath.row - 1].thumbName)!)
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        } // else condition to do something when clicking on a cell -- "toDetailedView"
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
