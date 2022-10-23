//
//  ViewController.swift
//  MovieProject
//
//  Created by Pranjal Verma on 18/10/22.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var searchText = ""
    
    let movieViewModel = MovieViewModel()
    var movieList: MovieListModel?
    var pageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchBar.delegate = self
        
        let nib = UINib(nibName: "MovieCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MovieCollectionCell")
//        movieViewModel.getData(pageNo: 1) { movieList in
//            self.movieList = movieList
//        }
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieList?.search.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as? MovieCollectionCell else {return MovieCollectionCell()}
        guard let imgUrl = movieList?.search[indexPath.row].posterURL else {return MovieCollectionCell()}
        movieViewModel.loadImage(url: imgUrl) { img in
            cell.configure(img: img)
        }
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height: 250)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let endScrolling = (scrollView.contentOffset.y + scrollView.frame.size.height)
        
        if endScrolling >= scrollView.contentSize.height {
            pageCount += 1
            print(pageCount)
            movieViewModel.getData(searchText: searchText,pageNo: pageCount) { movielist in
                let oldSearch = self.movieList?.search ?? []
                let combinedSearch = oldSearch + movielist.search
                let oldTotalResults = self.movieList?.totalResults
                let combinedResults = (oldTotalResults ?? "") + movielist.totalResults
                let oldTotalResponse = self.movieList?.response
                let combinedResponse = (oldTotalResponse ?? "") + movielist.response
                self.movieList = MovieListModel(search: combinedSearch, totalResults: combinedResults, response: combinedResponse)
            }
        }
    }
}


extension ViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        movieViewModel.getData(searchText: searchText, pageNo: 1) { movieList in
            self.movieList = movieList
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
