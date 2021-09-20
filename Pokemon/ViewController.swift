//
//  ViewController.swift
//  Pokemon
//
//  Created by Eder Barreto Oliveira on 06/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    typealias PokemonList = PokemonManager.PokemonList
    var pokemonList: PokemonList = PokemonList(pokemon: [])
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "PokemonCell")
        tableView.dataSource = self
        tableView.delegate = self
        PokemonManager.shared.getAllPokemons { (result: Result<PokemonList?, PokemonManager.ErrorType>) in
            switch result {
            case .success(let data):
                self.pokemonList = data ?? PokemonList(pokemon: [])
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure:
                break
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.pokemon.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as? PokemonCell, let url = URL(string: pokemonList.pokemon[indexPath.row].img ?? "")
        else {
            return UITableViewCell()
        }
        
        cell.name.text = pokemonList.pokemon[indexPath.row].name
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    cell.img.image = UIImage(data: data)
                }
            } catch {
                print("error")
            }
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let story = UIStoryboard(name: "PokemonDetails", bundle: nil).instantiateInitialViewController() as? PokemonDetailsController else {
            return
        }
        story.pokemon = pokemonList.pokemon[indexPath.row]
        navigationController?.pushViewController(story, animated: true)
    }
}
