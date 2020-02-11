//
//  ChangeStatusViewController.swift
//  RickM+
//
//  Created by RickSun on 2020/2/10.
//  Copyright © 2020 RickSun. All rights reserved.
//

import UIKit

class ChangeStatusViewController: UIViewController {
    @IBOutlet weak var defaultStatusTableView: UITableView!
    
    var defaultStatus = ["忙碌中",
                         "看電影中",
                         "工作中，賺錢要緊",
                         "裝忙中", "睡覺囉，有事等我醒再說",
                         "不方便說話，訊息可",
                         "心情不好中，不想說話",
                         "運動中，人總是要活動活動",
                         "只接緊急來電"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultStatusTableView.dataSource = self
        defaultStatusTableView.delegate = self
//        defaultStatusTableView.separatorStyle = .none
        
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ChangeStatusViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultStatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultStatus", for: indexPath) as? DefaultStatusTableViewCell else { return UITableViewCell()
        }
        cell.defaultStatusLabel.text = defaultStatus[indexPath.row]
        return cell
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        return "預設狀態"
//        
//    }
    
}
