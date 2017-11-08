//
//  FreeFoodTableViewController.swift
//  FreeFood
//
//  Created by 김종현 on 2017. 11. 2..
//  Copyright © 2017년 김종현. All rights reserved.
//

import UIKit

class FreeFoodTableViewController: UITableViewController, XMLParserDelegate {
    
    @IBOutlet var myTable: UITableView!
    
    var item:[String:String] = [:]
    var items:[[String:String]] = []
    var key = ""
    var servieKey = "XRcD2BtScfry3R19eGO%2FNR7cx9DTbKu4EOQjZiaDgTC48fA6Y1R7unCSNHsnKVzpSjVPfYtXFuzwEPclYn0Rew%3D%3D"
    var listEndPoint = "http://apis.data.go.kr/6260000/BusanBicycleInfoService/getBicycleRackInfo"
    let detailEndPoint = "http://apis.data.go.kr/6260000/BusanBicycleInfoService/getBicycleRackInfo"
    
    //추가
    var contents = NSArray()
    //여기까지 추가
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading")
        self.title = "부산 무료 급식소"
        
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("data.plist")
        
        //추가
        myTable.delegate = self
        myTable.dataSource = self
        let path = Bundle.main.path(forResource: "data", ofType: "plist")
        contents = NSArray(contentsOfFile: path!)!
        //여기까지
        
        if fileManager.fileExists(atPath: (url?.path)!) {
            items = NSArray(contentsOf: url!) as! Array
        } else {
            // 기본 목록 파싱
            getList()
            print("After getList = \(items)")
            
            let tempItems = items  // tableView에서 재활용
            items = []
        
            for dic in tempItems {
                // 상세 목록 파싱
                getDetail(idx: dic["idx"]!)
            }
            
            print("After getDetail = \(items)")
            
            let temp = items as NSArray  // NSArry는 화일로 저장하기 위함
            temp.write(to: url!, atomically: true)
       }
        
        tableView.reloadData()
        print("complete loading")
    }
    //추가
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    //여기까지
    
    func getList() {
        //let str = detailEndPoint + "?serviceKey=\(servieKey)&numsofRows=20"
        let str = listEndPoint + "?serviceKey=\(servieKey)&numOfRows=100"
        
        print(str)
        
        if let url = URL(string: str) {
            if let parser = XMLParser(contentsOf: url) {
                parser.delegate = self
                let success = parser.parse()
                if success {
                    print("parse success")
                    //print(item)
                    
                } else {
                    print("parse fail")
                }
            }
        }
    }
    
    func getDetail(idx: String) {
        let str = detailEndPoint + "?serviceKey=\(servieKey)&idx=\(idx)"
        
        if let url = URL(string: str) {
            if let parser = XMLParser(contentsOf: url) {
                parser.delegate = self
                let success = parser.parse()
                if success {
                    print("parse success")
                    //print(items)
                    
                } else {
                    print("parse fail")
                }
            }
        }
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        //key = elementName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        key = elementName
        if key == "item" {
            item = [:]
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        // foundCharacters가 두번 호출
        if item[key] == nil {
            item[key] = string.trimmingCharacters(in: .whitespaces)
            
            //print("****** \(item[key])")
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            items.append(item)
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "RE", for: indexPath)
        
        let dic = items[indexPath.row]
        cell.textLabel?.text = dic["spotGubun"]
        cell.detailTextLabel?.text = dic["setCnt"]

        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

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

       
}
