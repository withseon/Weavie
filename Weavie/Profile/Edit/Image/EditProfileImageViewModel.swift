//
//  EditProfileImageViewModel.swift
//  Weavie
//
//  Created by 정인선 on 2/8/25.
//

import Foundation

final class EditProfileImageViewModel {
    private var oldImageIndex: Int
    var inputImageIndex: Observable<Int?> = Observable(nil)
    var inputImageChange: Observable<Void?> = Observable(nil)
    var inputOldImageChange: Observable<Int?> = Observable(nil)
    private(set) var outputImageIndex: Observable<Int?> = Observable(nil)
    private(set) var outputImageChange: Observable<Int?> = Observable(nil)
    
    init(oldImageIndex: Int) {
        self.oldImageIndex = oldImageIndex
        bindData()
    }
    
    deinit {
        print("❗️EditProfile VM Deinit")
    }
    
    private func bindData() {
        inputImageIndex.lazyBind { [weak self] imageIndex in
            print("=== profileImage:: inputImageIndex bind")
            guard let self, let imageIndex else { return }
            updateSelectedImage(imageIndex)
        }
        inputImageChange.lazyBind { [weak self] _ in
            print("=== profileImage:: inputImageChange bind")
            guard let self else { return }
            changeImage()
        }
    }
}

extension EditProfileImageViewModel {
    private func updateSelectedImage(_ index: Int) {
        if index != outputImageIndex.value {
            outputImageIndex.value = index
        }
    }
    
    private func changeImage() {
        guard let selectedImageIndex = outputImageIndex.value else { return }
        if oldImageIndex != selectedImageIndex {
            outputImageChange.value = selectedImageIndex
            oldImageIndex = selectedImageIndex
        }
    }
}
