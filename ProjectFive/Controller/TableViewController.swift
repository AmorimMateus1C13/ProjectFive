//
//  ViewController.swift
//  ProjectFive
//
//  Created by Mateus Amorim on 12/09/22.
//

import UIKit

class TableViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        creatArrayByStar()
        tableView.isScrollEnabled = true
        tableView.register(CellTableViewTableViewCell.self, forCellReuseIdentifier: CellTableViewTableViewCell.identifier)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "StartGame", style: .plain, target: self, action: #selector(startGame))
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
                guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    showErrorMessage(rule: .isReal)
                }
            } else {
                showErrorMessage(rule: .isOriginal)
            }
        } else {
            showErrorMessage(rule: .isPossible)
        }
    }
    
    enum Rules {
        case isPossible
        case isOriginal
        case isReal
    }
    
    func showErrorMessage(rule: Rules) {
        let errorTitle: String
        let errorMessage: String
        
        switch rule {
        case .isPossible:
            guard let title = title?.lowercased() else { return }
            errorTitle = Errors.ErrorTitle.isPossible
            errorMessage = Errors.ErrorMessage.isPossible + title
        case .isOriginal:
            errorTitle = Errors.ErrorTitle.isOriginal
            errorMessage = Errors.ErrorMessage.isOrginal
        case .isReal:
            errorTitle = Errors.ErrorTitle.isReal
            errorMessage = Errors.ErrorMessage.isReal
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool{
        guard var tempWord = title?.lowercased() else { return false}
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }

    func isOriginal(word: String) -> Bool {
        return !allWords.contains(word)
    }
    
    func isReal(word: String) -> Bool{
        
        let check = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = check.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        if word.count <= 3 {
            return false
        }
        return misspelledRange.location == NSNotFound
    }
    
    
    func creatArrayByStar() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        startGame()
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellTableViewTableViewCell.identifier, for: indexPath) as? CellTableViewTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.label.text = usedWords[indexPath.row]
        return cell
    }
}
