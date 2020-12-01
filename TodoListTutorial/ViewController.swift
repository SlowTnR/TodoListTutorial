//
//  ViewController.swift
//  TodoListTutorial
//
//  Created by Ilja Patrushev on 1.12.2020.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var tasks = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tasks"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup save user defaults
        
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0,forKey: "count")
        }
        // get all saved tasks
        updateTasks()
        
    }
    
    func updateTasks(){
        
        tasks.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {return}
        
        for x in 0..<count {
            
            if let task = UserDefaults().value(forKey: "task_\(x + 1)") as? String {
                tasks.append(task)
            }
            
            
        }
        
        tableView.reloadData()
        
    }
    
    @IBAction func didTapAdd(){
        let entryVC = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        entryVC.title = "New Task"
        entryVC.update = {
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(entryVC, animated: true)
    }


}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let taskVC = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        taskVC.title = "Detailed Task"
        taskVC.task = tasks[indexPath.row]
       
        navigationController?.pushViewController(taskVC, animated: true)
    }
    
    
}

    


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row]
        
        return cell
    }
    
    
}
