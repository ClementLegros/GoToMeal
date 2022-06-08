//
//  AccueilViewController.swift
//  goToMeal2
//
//  Created by Kelvin Fernandes Monteiro on 31/05/2022.
//

import UIKit
import CoreData


class AccueilViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var listDefinitiveDePlat:[Plat] = [];
    @IBOutlet weak var tablePlat: UITableView!
    
    @IBOutlet weak var bienvenue: UILabel!
    
    var username:String = "";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablePlat.dataSource = self;
        tablePlat.delegate = self;
        bienvenue.text = "Bienvenue \(username) !";
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToScanner" {
            let destinationVC = segue.destination as! ScannerViewController
        }
    }
    
    @IBAction func retourDansLaVue1(segue: UIStoryboardSegue) {
        
        //tablePlat.register(UITableViewCell.self,
        //                       forCellReuseIdentifier: "TableViewCell")
        tablePlat.reloadData()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Code Here
        return listDefinitiveDePlat.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Code Here
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for:indexPath)
        cell.textLabel?.text = self.listDefinitiveDePlat[indexPath.row].description
                
        return cell
    }
}
    



