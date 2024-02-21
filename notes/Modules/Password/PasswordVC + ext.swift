import UIKit

extension PasswordViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 4 }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NumCell.identifier,
                for: indexPath
            ) as? NumCell
        else {
            fatalError("Cannot create num cell")
        }
        
        cell.cellData = numPadSymbols[indexPath.section][indexPath.row]
        cell.presenter = presenter
        
        return cell
    }
}
