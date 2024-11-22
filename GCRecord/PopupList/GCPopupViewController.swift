//
//  GCPopupViewController.swift
//  GCRecord
//
//  Created by Prank on 18/11/24.
//

import UIKit

class GCPopupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var data: [String] = []
    var selectedIndex: IndexPath? // Track the selected cell index
    private var popupHeight: CGFloat = 150
    
    // Callback for item selection
    var didSelectItem: ((String) -> Void)?
    
    // Initialization
    init(data: [String], selectedIndex: IndexPath? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.data = data
        self.selectedIndex = selectedIndex
        modalPresentationStyle = .popover
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        // Configure table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Layout table view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = indexPath.row % 2 == 0 ? .white : UIColor(hex: "#F2F2F2")
        
        // Add the tick icon to the selected row
        if indexPath == selectedIndex {
            let tickImage = UIImage(named: "tick_ico")
            cell.accessoryView = UIImageView(image: tickImage)
        } else {
            cell.accessoryView = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update the selected index
        selectedIndex = indexPath
        let selectedItem = data[indexPath.row]
        
        // Trigger callback and close the popup
        didSelectItem?(selectedItem)
        
        // Refresh table view to show the tick mark
        tableView.reloadData()
        
        // Dismiss the popup
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Public Methods
    
    func setPopupSize(width: CGFloat, height: CGFloat) {
        preferredContentSize = CGSize(width: width, height: height)
        popupHeight = height
    }
}
