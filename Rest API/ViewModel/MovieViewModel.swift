//
//  MovieViewModel.swift
//  Rest API
//
//  Created by Jakub Němec on 22.06.2021.
//

import Foundation

class MovieViewModel {
    
    private var apiservice = ApiService()
    private var popularMovies = [Movie]()
    
    func fetchPopularMoviesData(completion: @escaping () -> ()) {
        
        apiservice.getPopularMoviesData { [weak self] (result) in
            
            switch result{
                case .success(let listOf):
                    self?.popularMovies = listOf.movies
                    completion()
                case .failure(let error ):
                    print("Error processing json data: \(error)")
            }
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if popularMovies.count != 0{
            return popularMovies.count
        }
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Movie {
        return popularMovies[indexPath.row]
    }
}
