import UIKit

extension NoteViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        if addedImages.count > 1 {
            addedImages.removeFirst()
        }
        addedImages.append(image)
        imagesStackView.removeAllArrangedSubviews()
        for noteImage in addedImages {
            let newImage = noteImage.resized(toHeight: 60)
            
            let imageView = UIImageView(image: newImage)
            imagesStackView.addArrangedSubview(imageView)
        }
    }
}

extension NoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
