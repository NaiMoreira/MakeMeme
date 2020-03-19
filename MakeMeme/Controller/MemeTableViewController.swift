//
//  MemeTableViewController.swift
//  MakeMeme
//
//  Created by Nai on 16.03.20.
//  Copyright © 2020 Nai. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var indexPath = IndexPath()
    var memes: [Memes]! {
        let object = UIApplication.shared.delegate
        let appdelegate = object as! AppDelegate
        return appdelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addMeme", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTable", for: indexPath) as! MemeTableViewCell
        let memeImage = memes[indexPath.row]
        cell.memeImage.image = memeImage.memedImage
        cell.memeLabel.text = "\(memeImage.topText)...\(memeImage.bottomText)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPath = indexPath
        performSegue(withIdentifier: "tableMemeDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableMemeDetail" {
            let destinationView = segue.destination as! MemeDetailViewController
            let destMeme = memes[indexPath.row]
            destinationView.topText = destMeme.topText
            destinationView.bottomText = destMeme.bottomText
            destinationView.originalImg = destMeme.originalImage
            destinationView.memeImg = destMeme.memedImage
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        
        deleteAction.image = UIImage.init(systemName: "trash")
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }

}
