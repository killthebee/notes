import UIKit

extension MainViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 1:
            return 30
            // return notes.count or smthng
        default:
            return 1
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 2 }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: YearSubHeaderCell.cellIdentifier,
                    for: indexPath
                ) as? YearSubHeaderCell
            else {
                fatalError("Unable deque cell...")
            }
            
            return cell
        }
        
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NoteCell.cellIdentifier,
                for: indexPath
            ) as? NoteCell
        else {
            fatalError("Unable deque cell...")
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TopBannerCell.cellIdentifier,
                for: indexPath
            ) as? TopBannerCell
        else {
            fatalError("Cannot create header view")
        }
        supplementaryView.scrollviewDidScroll(scrollView: collectionView)
        
        return supplementaryView
    }
}
