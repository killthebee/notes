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
            return notes.count == 0 ? 0 : notes.count
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
                    withReuseIdentifier: TopBannerSubCell.cellIdentifier,
                    for: indexPath
                ) as? TopBannerSubCell
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
        cell.cellData = notes[indexPath.row]
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if indexPath.section == 0 {
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
        guard
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: YearHeaderCell.cellIdentifier,
                for: indexPath
            ) as? YearHeaderCell
        else {
            fatalError("Cannot create header view")
        }
        
        return supplementaryView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            presenter?.presentNoteScreen(
                notes[indexPath.row]
            )
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offestY = scrollView.contentOffset.y
        if abs(offestY) > 250 {
            yearHeaderContainer.isHidden = false
        } else {
            yearHeaderContainer.isHidden = true
        }
        
//        print(scrollView.contentOffset.y)
//        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
//        let visiblePoint = CGPoint(x: 100, y: visibleRect.midY)
//        let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint)
//        print(visibleIndexPath)
//        if let row = visibleIndexPath?.row{
//            print(notes[row].header)
//        }
            
    }
    
}
