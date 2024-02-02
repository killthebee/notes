import UIKit

extension NoteViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        guard let image = image?.resized(toHeight: 60) else {
            return
        }
        if addedImages.count > 1 {
            addedImages.removeFirst()
        }
        addedImages.append(image)
        imagesStackView.removeAllArrangedSubviews()
        for noteImage in addedImages {
            let newImage = noteImage
            
            let imageView = UIImageView(image: newImage)
            imagesStackView.addArrangedSubview(imageView)
        }
    }
}

extension NoteViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1337 {
            isTextInput = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isTextInput = false
    }
}
