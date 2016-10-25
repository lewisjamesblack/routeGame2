//
//  MenuViewController.swift
//  routeGame2
//
//  Created by Lewis Black on 02/09/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit


class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
       
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDescLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let games = DataCheck().firstApp
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = self.games[(indexPath as NSIndexPath).row][2] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let numberOfCols = Route().numberOfCols
        let numberOfRows = Route().numberOfRows
        let routeCoOrds = Route().getRoute(Int(arc4random_uniform(2)) ,type: 3)!
        //Int(arc4random_uniform(4))

        let minWordLengthIfNoSmaller = 4
        let maxWordLengthIfNoBigger = 9
        let dataBeforeTranslation = games[(indexPath as NSIndexPath).row]
        
        let game = Game(numberOfCols: numberOfCols, numberOfRows: numberOfRows, routeCoOrds: routeCoOrds, minWordLengthIfNoSmaller: minWordLengthIfNoSmaller, maxWordLengthIfNoBigger: maxWordLengthIfNoBigger, dataBeforeTranslation: dataBeforeTranslation as [AnyObject])
        self.performSegue(withIdentifier: SEGUE_GAME_SELECTED, sender: game)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameViewController: GameViewController = segue.destination as? GameViewController {
            
            if let sent = sender as? Game {
                gameViewController.game = sent
            }
        }
    }
    
    
}
