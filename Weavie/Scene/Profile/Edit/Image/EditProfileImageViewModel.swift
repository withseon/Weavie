//
//  EditProfileImageViewModel.swift
//  Weavie
//
//  Created by 정인선 on 2/8/25.
//

import Foundation

final class EditProfileImageViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output
    private var oldImageIndex: Int
    
    struct Input {
        var imageIndex: Observable<Int> = Observable(EmptyValue.index)
        var imageChange: Observable<Void> = Observable(())
        var oldImageChange: Observable<Int> = Observable(EmptyValue.index)
    }
    
    struct Output {
        private(set) var imageIndex: Observable<Int> = Observable(EmptyValue.index)
        var imageChange: Observable<Int> = Observable(EmptyValue.index)
    }
    
    init(oldImageIndex: Int) {
        self.oldImageIndex = oldImageIndex
        input = Input()
        output = Output()
        transform()
    }
    
    deinit {
        print("❗️EditProfile VM Deinit")
    }
    
    func transform() {
        input.imageIndex.lazyBind { [weak self] imageIndex in
            print("=== profileImage:: inputImageIndex bind")
            guard let self else { return }
            updateSelectedImage(imageIndex)
        }
        input.imageChange.lazyBind { [weak self] _ in
            print("=== profileImage:: inputImageChange bind")
            guard let self else { return }
            changeImage()
        }
    }
}

extension EditProfileImageViewModel {
    private func updateSelectedImage(_ index: Int) {
        if index != output.imageIndex.value {
            output.imageIndex.value = index
        }
    }
    
    private func changeImage() {
        let selectedImageIndex = output.imageIndex.value
        if oldImageIndex != selectedImageIndex {
            output.imageChange.value = selectedImageIndex
            oldImageIndex = selectedImageIndex
        }
    }
}
