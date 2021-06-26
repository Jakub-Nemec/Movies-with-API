//
//  MovieViewController.swift
//  Rest API
//
//  Created by Jakub Němec on 22.06.2021.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let titleLabel = UILabel()
    let tableView = UITableView()
    let blackBar = UILabel()
    
    private var viewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .orange
        //Setup view
        setup()
    }
    
    func setup(){
        prepareLabel()
        prepareTableView()
        loadPopularMoviesData()
        prepareblackBar()
    }
    
    private func loadPopularMoviesData() {
        viewModel.fetchPopularMoviesData { [weak self] in
            self?.tableView.dataSource = self
            self?.tableView.reloadData()
        }
    }
    
    
    //Preparing label
    func prepareLabel() {
        view.addSubview(titleLabel)
        titleLabel.text = "Popular Movies"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .cyan
        titleLabel.font = UIFont(name: "Arial", size: 30)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.backgroundColor = .black
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(80)
        }
    }
    
    func prepareblackBar() {
        view.addSubview(blackBar)
        blackBar.backgroundColor = .lightGray
        blackBar.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    //Preparing TableView
    func prepareTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
            
            let movie = viewModel.cellForRowAt(indexPath: indexPath)
            cell.setCellWithValuesOf(movie)
            
            return cell
        }
}
