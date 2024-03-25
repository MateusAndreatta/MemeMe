//
//  ListViewController.swift
//  MemeMe
//
//  Created by Mateus Andreatta on 20/03/24.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    private var selectedMeme: Meme? = nil
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .black
        configureItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func configureItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
    }
    
    @objc func didTapAddButton() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewMeme") as! ViewController
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "MemeTableViewCell")
        cell.textLabel?.text = "\(memes[indexPath.row].topText) ... \(memes[indexPath.row].bottomText)"
        cell.imageView?.image = memes[indexPath.row].memedImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMeme = memes[indexPath.row]
        performSegue(withIdentifier: "ShowMeme2Segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! ShowMemeViewController
        if let selectedMeme {
            controller.setup(with: selectedMeme)
        }
    }
}
