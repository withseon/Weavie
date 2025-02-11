//
//  EditProfileNicknameViewModel.swift
//  Weavie
//
//  Created by 정인선 on 2/7/25.
//

import Foundation


final class EditProfileNicknameViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output
    private var oldUser: User?
    private var nickname = ""
    private var isNicknameValid = false
    let mbtiTitles = ["E", "S", "T", "J", "I", "N", "F", "P"]
    private var selectedMBTIData = [String: Bool]()
    
    struct Input {
        var user: Observable<User?> = Observable(nil)
        var nickname: Observable<String> = Observable(EmptyValue.text)
        var imageIndex: Observable<Int> = Observable(EmptyValue.index)
        var selectedIndex: Observable<Int> = Observable(EmptyValue.index)
        var deselectedIndex: Observable<Int> = Observable(EmptyValue.index)
        var userDefaultsSave: Observable<Void> = Observable(())
        var notificationPost: Observable<Void> = Observable(())
    }
    
    struct Output {
        var user: Observable<(nickname: String, mbtiIndicies: [Int])> = Observable((EmptyValue.text, []))
        var nicknameState: Observable<String> = Observable(EmptyValue.text)
        var imageIndex: Observable<Int> = Observable((0..<Resource.AssetImage.profileCount).randomElement() ?? 0)
        var deselectedIndex: Observable<Int> = Observable(EmptyValue.index)
        var buttonEnable: Observable<Bool> = Observable(false)
        var userDefaultsDone: Observable<Void> = Observable(())
        var notificationPost: Observable<Void> = Observable(())
    }
        
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    deinit {
        print("❗️EditNickname VM Deinit")
    }
    
    func transform() {
        input.user.lazyBind { [weak self] user in
            print("=== inputUser bind")
            guard let self, let user else { return }
            updateUserInfo(user: user)
            updateDoneButtonState()
        }
        input.nickname.lazyBind { [weak self] text in
            print("=== inputNickname bind")
            guard let self else { return }
            validateNickname(text)
        }
        input.imageIndex.lazyBind { [weak self] index in
            print("=== inputImageIndex bind")
            guard let self else { return }
            output.imageIndex.value = index
        }
        input.selectedIndex.lazyBind { [weak self] index in
            print("=== inputSelectedIndex bind")
            guard let self else { return }
            selectedIndex(index)
        }
        input.deselectedIndex.lazyBind { [weak self] index in
            print("=== inputDeselectedIndex bind")
            guard let self else { return }
            deselectedIndex(index)
        }
        input.userDefaultsSave.lazyBind { [weak self] _ in
            print("=== inputUserDefaultsSave bind")
            guard let self else { return }
            saveUserDefaults()
        }
        input.notificationPost.lazyBind { [weak self] _ in
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
        output.user.value = (user.nickname, user.mbti)
        output.imageIndex.value = user.imageIndex
    }
    
    private func updateDoneButtonState() {
        isNicknameValid = true
        validateDoneButton()
    }
}

// MARK: - 완료 버튼 enable 설정
extension EditProfileNicknameViewModel {
    private func validateDoneButton() {
        let isMBTIValid = selectedMBTIData.count == 4
        output.buttonEnable.value = isNicknameValid && isMBTIValid ? true : false
    }
}

// MARK: - 닉네임 유효성 검증
extension EditProfileNicknameViewModel {
    private func validateNickname(_ text: String?) {
        let specialCharSet = CharacterSet(charactersIn: "@#$%")
        guard let currentText = text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if currentText.count < 2 || currentText.count > 9 {
            output.nicknameState.value = NicknameState.lengthViolation.rawValue
            isNicknameValid = false
        } else if currentText.rangeOfCharacter(from: .whitespacesAndNewlines) != nil {
            output.nicknameState.value = NicknameState.whitespaceViolation.rawValue
            isNicknameValid = false
        } else if currentText.rangeOfCharacter(from: .decimalDigits) != nil {
            output.nicknameState.value = NicknameState.numberViolation.rawValue
            isNicknameValid = false
        } else if currentText.rangeOfCharacter(from: specialCharSet) != nil {
            output.nicknameState.value = NicknameState.specialCharacterViolation.rawValue
            isNicknameValid = false
        } else {
            output.nicknameState.value = NicknameState.correct.rawValue
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
            output.deselectedIndex.value = deselectedIndex
            selectedMBTIData[mbtiTitles[deselectedIndex]] = nil
        } else {
            let deselectedIndex = index + 4
            output.deselectedIndex.value = deselectedIndex
            selectedMBTIData[mbtiTitles[deselectedIndex]] = nil
        }
        validateDoneButton()
    }
    
    // deselected 됐을 때
    private func deselectedIndex(_ index: Int) {
        selectedMBTIData[mbtiTitles[index]] = nil
        validateDoneButton()
    }
}

// MARK: - UserDefaults 저장
extension EditProfileNicknameViewModel {
    private func saveUserDefaults() {
        let mbtiIndices = selectedMBTIData.compactMap { mbtiTitles.firstIndex(of: $0.key) }
        if let oldUser {
            if oldUser.nickname != nickname || oldUser.imageIndex != output.imageIndex.value || oldUser.mbti != mbtiIndices {
                UserDefaultsManager.user = User(nickname: nickname,
                                                imageIndex: output.imageIndex.value,
                                                mbti: mbtiIndices,
                                                registerDate: oldUser.registerDate)
            }
        } else {
            UserDefaultsManager.user = User(nickname: nickname,
                                            imageIndex: output.imageIndex.value,
                                            mbti: mbtiIndices,
                                            registerDate: Date())
            UserDefaultsManager.likedMovies = []
            UserDefaultsManager.searchRecord = [:]
        }
        output.userDefaultsDone.value = ()
    }
}

// MARK: - Notification post
extension EditProfileNicknameViewModel {
    private func postNotification() {
        NotificationManager.center.post(name: .user, object: nil)
        output.notificationPost.value = ()
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
