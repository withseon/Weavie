//
//  EditProfileNicknameViewModel.swift
//  Weavie
//
//  Created by 정인선 on 2/7/25.
//

import Foundation


final class EditProfileNicknameViewModel {
    var inputUser: Observable<User?> = Observable(nil)
    var inputNickname: Observable<String?> = Observable(nil)
    var inputImageIndex: Observable<Int?> = Observable(nil)
    var inputSelectedIndex: Observable<Int?> = Observable(nil)
    var inputDeselectedIndex: Observable<Int?> = Observable(nil)
    var inputUserDefaultsSave: Observable<Void?> = Observable(nil)
    var inputNotificationPost: Observable<Void?> = Observable(nil)
    
    private(set) var outputUser: Observable<(nickname: String, mbtiIndicies: [Int])?> = Observable(nil)
    private(set) var outputNicknameState: Observable<String?> = Observable(nil)
    private(set) var outputImageIndex: Observable<Int> = Observable((0..<Resource.AssetImage.profileCount).randomElement() ?? 0)
    private(set) var outputDeselectedIndex: Observable<Int?> = Observable(nil)
    private(set) var outputButtonEnable: Observable<Bool> = Observable(false)
    private(set) var outputUserDefaultsDone: Observable<Void?> = Observable(nil)
    private(set) var outputNotificationPost: Observable<Void?> = Observable(nil)
    
    private var oldUser: User?
    private var nickname = ""
    private var isNicknameValid = false
    let mbtiTitles = ["E", "S", "T", "J", "I", "N", "F", "P"]
    private var selectedMBTIData = ["E": false,
                                    "S": false,
                                    "T": false,
                                    "J": false,
                                    "I": false,
                                    "N": false,
                                    "F": false,
                                    "P": false]
    
    init() {
        bind()
    }
    
    deinit {
        print("❗️EditNickname VM Deinit")
    }
    
    private func bind() {
        inputUser.lazyBind { [weak self] user in
            print("=== inputUser bind")
            guard let self, let user else { return }
            updateUserInfo(user: user)
            updateDoneButtonState()
        }
        inputNickname.lazyBind { [weak self] text in
            print("=== inputNickname bind")
            guard let self else { return }
            validateNickname(text)
        }
        inputImageIndex.lazyBind { [weak self] index in
            print("=== inputImageIndex bind")
            guard let self, let index else { return }
            outputImageIndex.value = index
        }
        inputSelectedIndex.lazyBind { [weak self] index in
            print("=== inputSelectedIndex bind")
            guard let self, let index else { return }
            selectedIndex(index)
        }
        inputDeselectedIndex.lazyBind { [weak self] index in
            print("=== inputDeselectedIndex bind")
            guard let self, let index else { return }
            deselectedIndex(index)
        }
        inputUserDefaultsSave.lazyBind { [weak self] _ in
            print("=== inputUserDefaultsSave bind")
            guard let self else { return }
            saveUserDefaults()
        }
        inputNotificationPost.lazyBind { [weak self] _ in
            print("=== inputNotificationPost bind")
            guard let self else { return }
            postNotification()
        }
    }
}

// MARK: - 초기 User 정보에 대한 UI 업데이트 output
extension EditProfileNicknameViewModel {
    private func updateUserInfo(user: User) {
        oldUser = user
        nickname = user.nickname
        user.mbti.forEach { selectedMBTIData[mbtiTitles[$0]] = true }
        outputUser.value = (user.nickname, user.mbti)
        outputImageIndex.value = user.imageIndex
    }
    
    private func updateDoneButtonState() {
        isNicknameValid = true
        validateDoneButton()
    }
}

// MARK: - 완료 버튼 enable 설정
extension EditProfileNicknameViewModel {
    private func validateDoneButton() {
        let isMBTIValid = selectedMBTIData.values.filter { $0 }.count == 4
        outputButtonEnable.value = isNicknameValid && isMBTIValid ? true : false
    }
}

// MARK: - 닉네임 유효성 검증
extension EditProfileNicknameViewModel {
    private func validateNickname(_ text: String?) {
        let specialCharSet = CharacterSet(charactersIn: "@#$%")
        guard let currentText = text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if currentText.count < 2 || currentText.count > 9 {
            outputNicknameState.value = NicknameState.lengthViolation.rawValue
            isNicknameValid = false
        } else if currentText.rangeOfCharacter(from: .whitespacesAndNewlines) != nil {
            outputNicknameState.value = NicknameState.whitespaceViolation.rawValue
            isNicknameValid = false
        } else if currentText.rangeOfCharacter(from: .decimalDigits) != nil {
            outputNicknameState.value = NicknameState.numberViolation.rawValue
            isNicknameValid = false
        } else if currentText.rangeOfCharacter(from: specialCharSet) != nil {
            outputNicknameState.value = NicknameState.specialCharacterViolation.rawValue
            isNicknameValid = false
        } else {
            outputNicknameState.value = NicknameState.correct.rawValue
            nickname = currentText
            isNicknameValid = true
        }
        validateDoneButton()
    }
}

// MARK: - MBTI 설정
extension EditProfileNicknameViewModel {
    // selected 됐을 때
    private func selectedIndex(_ index: Int) {
        selectedMBTIData[mbtiTitles[index]] = true
        if index > 3 {
            let deselectedIndex = index - 4
            outputDeselectedIndex.value = deselectedIndex
            selectedMBTIData[mbtiTitles[deselectedIndex]] = false
        } else {
            let deselectedIndex = index + 4
            outputDeselectedIndex.value = deselectedIndex
            selectedMBTIData[mbtiTitles[deselectedIndex]] = false
        }
        validateDoneButton()
    }
    
    // deselected 됐을 때
    private func deselectedIndex(_ index: Int) {
        selectedMBTIData[mbtiTitles[index]] = false
        validateDoneButton()
    }
}

// MARK: - UserDefaults 저장
extension EditProfileNicknameViewModel {
    private func saveUserDefaults() {
        let mbtiIndices = selectedMBTIData.filter { $0.value }.keys.compactMap { mbtiTitles.firstIndex(of: $0) }
        if let oldUser {
            UserDefaultsManager.user = User(nickname: nickname,
                                            imageIndex: outputImageIndex.value,
                                            mbti: mbtiIndices,
                                            registerDate: oldUser.registerDate)
        } else {
            UserDefaultsManager.user = User(nickname: nickname,
                                            imageIndex: outputImageIndex.value,
                                            mbti: mbtiIndices,
                                            registerDate: Date())
            UserDefaultsManager.likedMovies = []
            UserDefaultsManager.searchRecord = [:]
        }
        outputUserDefaultsDone.value = ()
    }
}

// MARK: - Notification post
extension EditProfileNicknameViewModel {
    private func postNotification() {
        NotificationManager.center.post(name: .user, object: nil)
        outputNotificationPost.value = ()
    }
}

extension EditProfileNicknameViewModel {
    private enum NicknameState: String {
        case correct = "사용할 수 있는 닉네임이에요."
        case lengthViolation = "2글자 이상 10글자 미만으로 설정해 주세요."
        case specialCharacterViolation = "닉네임이 @,#,$,%는 포함할 수 없어요."
        case numberViolation = "닉네임에 숫자는 포함할 수 없어요."
        case whitespaceViolation = "닉네임에 공백은 포함할 수 없어요."
    }
}
