//
//  ContentView.swift
//  MoviesSwiftUI
//
//  Created by bartek on 11/01/2024.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var movies: [Movie] = []
    @State private var search: String = ""
    @State private var cancellables: Set<AnyCancellable> = []
    
    let httpClient: HTTPClient
    private var searchSubject = CurrentValueSubject<String, Never>("")
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    private func setupSearchPublisher() {
        searchSubject
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { searchText in
                loadMovies(search: searchText)
            }.store(in: &cancellables)

    }
    private func loadMovies(search: String) {
        httpClient.fetchMovies(search: search)
            .sink { _ in
                
            } receiveValue: { movies in
                self.movies = movies
            }.store(in: &cancellables)

    }
    
    var body: some View {
        List(movies) { movie in
            HStack {
                AsyncImage(url: movie.poster) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                } placeholder: {
                    ProgressView()
                }
                
                Text(movie.title)
            }
        }
        .onAppear() {
            setupSearchPublisher()
        }
        .searchable(text: $search)
            .onChange(of: search) { newValue in
                searchSubject.send(search)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView(httpClient: HTTPClient())
        }
    }
}
