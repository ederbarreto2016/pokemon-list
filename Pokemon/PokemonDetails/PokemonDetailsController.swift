//
//  PokemonDetailsController.swift
//  Pokemon
//
//  Created by Eder Barreto Oliveira on 07/07/21.
//

import UIKit

class PokemonDetailsController: UIViewController {
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var pokemon: PokemonManager.Pokemon?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = pokemon?.name
        getImage()
    }
    
    func getImage(){
        guard let url = URL(string: pokemon?.img ?? "") else { return }
        
        weightLabel.text = "weight: \(pokemon?.weight ?? "")"
        heightLabel.text = "height \(pokemon?.height ?? "")"
        
        imgView.alpha = .zero
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.imgView.image = UIImage(data: data)
                    UIView.animate(withDuration: 0.5) {
                        self.imgView.alpha = 1
                    }
                }
            } catch {
                print("error")
            }
        }
    }
}
