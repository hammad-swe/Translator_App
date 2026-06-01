//
//  LanguagePickerViewController.swift
//  Translator_App
//
//  Created by Hammad Ali on 21/05/2026.
//

import UIKit

class LanguagePickerViewController: UIViewController {
 
    
   // IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var languageTableView: UITableView!
    // MARK: - Properties
    weak var delegate: LanguagePickerDelegate?
        private var languages: [Language] = []
        private var filteredLanguages: [Language] = []
        private var selectedLanguage: Language? = nil
        private var isSource: Bool =  false
    
//    private let suggested: [Language] = [
//            Language(code: "en", name: "English"),
//            Language(code: "ur", name: "Urdu"),
//            Language(code: "ar", name: "Arabic"),
//            Language(code: "hi", name: "Hindi"),
//            Language(code: "zh", name: "Chinese")
//        ]
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isSearching: Bool {
        !(searchController.searchBar.text?.isEmpty ?? true)
    }

    // MARK: - Init from XIB
    init(languages: [Language], selected: Language?, isSource: Bool) {
        self.languages = languages
        self.selectedLanguage = selected
        self.isSource = isSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }



    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = isSource ? "Source Language" : "Target Language"
        
        setupTableView()
        setupSearchBar()
        setupNavBar()
        
     
    }
    private func setupNavBar() {
            navigationItem.title = isSource ? "Source Language" : "Target Language"
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(closeTapped)
            )
        }
    
    private func setupTableView() {
        languageTableView.delegate = self
        languageTableView.dataSource = self
        languageTableView.register(
            UINib(nibName: "LanguageTableViewCell", bundle: nil),
            forCellReuseIdentifier: LanguageTableViewCell.identifier
        )
        languageTableView.separatorInset = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 0)
        languageTableView.backgroundColor = .systemGroupedBackground
        }

        private func setupSearchBar() {
            searchController.searchResultsUpdater = self
                    searchController.obscuresBackgroundDuringPresentation = false
                    searchController.searchBar.placeholder = "Search language..."
                    definesPresentationContext = true
//            searchBar.delegate = self
//            searchBar.placeholder = "Search language..."
//            searchBar.backgroundImage = UIImage()
        }
    
    // MARK: - Actions
        @objc private func closeTapped() {
            dismiss(animated: true)
        }

    // MARK: - Helpers
        private func currentLanguages() -> [Language] {
            isSearching ? filteredLanguages : languages
        }

//        private func flag(for code: String) -> String {
//            let flags: [String: String] = [
//                "en": "🇬🇧", "ur": "🇵🇰", "ar": "🇸🇦", "fr": "🇫🇷",
//                "de": "🇩🇪", "es": "🇪🇸", "zh": "🇨🇳", "hi": "🇮🇳",
//                "tr": "🇹🇷", "ru": "🇷🇺", "ja": "🇯🇵", "ko": "🇰🇷",
//                "it": "🇮🇹", "pt": "🇵🇹", "bn": "🇧🇩", "fa": "🇮🇷",
//                "nl": "🇳🇱", "pl": "🇵🇱", "sv": "🇸🇪", "id": "🇮🇩",
//                "ms": "🇲🇾", "th": "🇹🇭", "vi": "🇻🇳", "el": "🇬🇷"
//            ]
//            return flags[code.lowercased()] ?? "🌐"
//        }
}

// MARK: - UITableViewDataSource
extension LanguagePickerViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        currentLanguages().count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = languageTableView.dequeueReusableCell(
            withIdentifier: LanguageTableViewCell.identifier,
            for: indexPath
        ) as? LanguageTableViewCell else { fatalError("Issue in cell class") }

        let lang = currentLanguages()[indexPath.row]
        let isSelected = lang.code == selectedLanguage?.code

        cell.configure(with: lang, isSelected: isSelected)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension LanguagePickerViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        languageTableView.deselectRow(at: indexPath, animated: true)
        let lang = currentLanguages()[indexPath.row]
        delegate?.didSelectLanguage(lang, isSource: isSource)
        self.navigationController?.popViewController(animated: true)    }
}

// MARK: - UISearchResultsUpdating
extension LanguagePickerViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        filteredLanguages = languages.filter {
            $0.name.lowercased().contains(query.lowercased()) ||
            $0.code.lowercased().contains(query.lowercased())
        }
        languageTableView.reloadData()
    }
}
