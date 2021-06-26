//
//  MovieTableViewCell.swift
//  Rest API
//
//  Created by Jakub Němec on 22.06.2021.
//

import UIKit
import SnapKit
import Alamofire

class MovieTableViewCell: UITableViewCell {
    
    var moviePoster = UIImageView()
    var starImg = UIImageView()
    var movieTitle = UILabel()
    var movieYear = UILabel()
    var movieOverview = UILabel()
    var movieRate = UILabel()
    var star = UIImage(named: "ratedStar.png")
    
    private var urlString: String = ""
    
    //Prepare cell
    
    override public init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        prepareMoviePoster()
        prepareMovieTitle()
        prepareMovieYear()
        prepareMovieOverview()
        prepareStarImg()
        prepareMovieRate()
    }
    
    func prepareStarImg(){
        self.addSubview(starImg)
        starImg.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.rightMargin.equalTo(movieTitle.snp.right).offset(80)
        }
        starImg.image = star
    }
    
    func prepareMoviePoster() {
        contentView.addSubview(moviePoster)
        moviePoster.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(85)
            make.height.equalTo(125)
            make.top.equalToSuperview().offset(15)
        }
    }
    
    func prepareMovieTitle() {
        contentView.addSubview(movieTitle)
        movieTitle.textColor = .black
        movieTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.rightMargin.equalTo(moviePoster.snp.right).offset(200)
        }
    }
    
    func prepareMovieYear() {
        contentView.addSubview(movieYear)
        movieYear.textColor = .gray
        movieYear.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.bottom)
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.rightMargin.equalTo(moviePoster.snp.right).offset(200)
        }
    }
    
    func prepareMovieOverview() {
        contentView.addSubview(movieOverview)
        movieTitle.textColor = .black
        movieOverview.snp.makeConstraints { make in
            make.top.equalTo(movieYear.snp.bottom).offset(15)
            make.width.equalTo(280)
            make.height.equalTo(30)
            make.rightMargin.equalTo(moviePoster.snp.right).offset(280)
        }
    }
    
    func prepareMovieRate() {
        contentView.addSubview(movieRate)
        movieRate.textAlignment = .center
        movieRate.textColor = .black
        movieRate.snp.makeConstraints { make in
            make.top.equalTo(starImg.snp.bottom).offset(2)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.rightMargin.equalTo(moviePoster.snp.right).offset(287)
        }
    }
    
    // Setup movies values
        func setCellWithValuesOf(_ movie:Movie) {
            updateUI(title: movie.title, releaseDate: movie.year, rating: movie.rate, overview: movie.overview, poster: movie.posterImage)
        }
        
        // Update the UI Views
        private func updateUI(title: String?, releaseDate: String?, rating: Double?, overview: String?, poster: String?) {
            
            self.movieTitle.text = title
            self.movieYear.text = convertDateFormater(releaseDate)
            guard let rate = rating else {return}
            self.movieRate.text = String(rate)
            self.movieOverview.text = overview
            
            guard let posterString = poster else {return}
            urlString = "https://image.tmdb.org/t/p/w300" + posterString
            
            guard let posterImageURL = URL(string: urlString) else {
                self.moviePoster.image = UIImage(named: "noImageAvailable")
                return
            }
            
            // Before we download the image we clear out the old one
            self.moviePoster.image = nil
            
            getImageDataFrom(url: posterImageURL)
            
        }
        
        // MARK: - Get image data
        private func getImageDataFrom(url: URL) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                // Handle Error
                if let error = error {
                    print("DataTask error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    // Handle Empty Data
                    print("Empty Data")
                    return
                }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.moviePoster.image = image
                    }
                }
            }.resume()
        }
        
        // MARK: - Convert date format
        func convertDateFormater(_ date: String?) -> String {
            var fixDate = ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let originalDate = date {
                if let newDate = dateFormatter.date(from: originalDate) {
                    dateFormatter.dateFormat = "dd.MM.yyyy"
                    fixDate = dateFormatter.string(from: newDate)
                }
            }
            return fixDate
        }
}
