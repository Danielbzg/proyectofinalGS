//
//  SearchView.swift
//  Cartelerapp
//
//  Created by alp1 on 17/4/23.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var movies: [MovieSR] = []
    
    var body: some View {
        VStack{
            //Creación de la barra de búsqueda
            HStack {
                TextField("Busca la película", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    //print("Valor de la variable text en la struct del SearchBar: \(searchText)")
                    searchMoviesView()
                }) {
                    Image(systemName: "magnifyingglass")
                        .padding(.horizontal)
                }
            }
            .padding()
            ScrollView(.vertical) {
                
                ForEach(movies) { movieItem in
                    VStack {
                        
                        NavigationLink {
                            
                            MovieDetailView(movie: Dependencies.repository.movieSearchResultToMovieIndividual(movieSearch: movieItem))
                            
                        } label: {
                            HStack(spacing: 16){
                                VStack(alignment: .center){
                                    AsyncImage(url: RemoteImage.movieImage(path: movieItem.posterPath ?? "")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(12)
                                        
                                    } placeholder: {
                                        
                                        ProgressView()
                                            .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.2, alignment: .center)
                                        
                                    }
                                }
                                .frame(minWidth:32, minHeight:135.05)
                                .cornerRadius(8)
                                
                                
                                VStack(alignment: .leading, spacing: 4){
                                    Text(movieItem.title)
                                        .font(.callout.bold())
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(Color.dsTitle)
                                    HStack{
                                        Image(systemName: "film")
                                            .foregroundColor(Color.dsSecondary)
                                        Text(String(movieItem.releaseDate))
                                            .font(.footnote)
                                            .foregroundColor(Color.dsSecondary)
                                    }
                                    HStack{
                                        Image(systemName: "clock")
                                            .foregroundColor(Color.dsSecondary)
                                        Text(String(movieItem.title) + " min.")
                                            .font(.footnote)
                                            .foregroundColor(Color.dsSecondary)
                                    }
                                    
                                }
                                .foregroundColor(.white)
                                .frame(minWidth: 200, minHeight: 86, alignment: .leading)
                            }.padding(8)
                        }
                    }
                    .padding(8)
                    .background(Color.dsBackgroundList)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .cornerRadius(12)
                }
            }
        }
        .background(Color.dsMain)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("Logo")
            }
        }
    }
    
    func searchMoviesView() {
        Task {
            do {
                print("El texto a buscar es \(self.searchText)")
                let movies = try await Dependencies.repository.searchMovies(searchText: self.searchText)
                print(movies)
                self.movies = movies
            } catch {
                print(error)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

