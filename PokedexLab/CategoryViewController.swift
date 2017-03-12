//
//  CategoryViewController.swift
//  PokedexLab
//
//  Created by SAMEER SURESH on 2/25/17.
//  Copyright © 2017 iOS Decal. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewCategory: UITableView!
    
    var pokemonArray: [Pokemon]?
    var cachedImages: [Int:UIImage] = [:]
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewCategory.delegate = self
        tableViewCategory.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonArray!.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tvCell", for: indexPath) as! tableviewcell
        let poke = pokemonArray![indexPath.row]
        if cachedImages[indexPath.row] != nil {
            cell.pokeImage.image = UIImage(named: poke.imageUrl)
        } else {
            let url = URL(string: poke.imageUrl)!
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            self.cachedImages[indexPath.row] = image
                            cell.pokeImage.image = UIImage(data: imageData) // may need to change this!
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code")
                    }
                }
            }
            downloadPicTask.resume()
        }
        cell.pokeName.text = poke.name
        cell.pokeNum.text = "#" + String(poke.number)
        cell.pokeStats.text = String(poke.attack) + "/" + String(poke.defense) + "/" + String(poke.health)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "categoryToPokeInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = PokemonInfoViewController()
        dest.pokemon = pokemonArray![selectedIndexPath!.row]
        dest.image = cachedImages[selectedIndexPath!.row]
    }

}
