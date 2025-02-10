//
//  WeavieResource.swift
//  Weavie
//
//  Created by 정인선 on 1/31/25.
//

import Foundation

enum Resource {
    static let appName = "Weavie"
}

// MARK: - 이미지
extension Resource {
    enum AssetImage {
        static let profileCount = 12
        case profile(_ index: Int)
        case onbaording
        
        var path: String {
            switch self {
            case .profile(let index):
                return "profile_\(index)"
            case .onbaording:
                return "onboarding"
            }
        }
    }
}

// MARK: - 영화 장르
extension Resource {
    enum Genre: Int, CaseIterable {
        case action = 28
        case animation = 16
        case crime = 80
        case drama = 18
        case fantasy = 14
        case horror = 27
        case mystery = 9648
        case sf = 878
        case thriller = 53
        case west = 37
        case adventure = 12
        case comedy = 35
        case documentary = 99
        case family = 10751
        case history = 36
        case music = 10402
        case romance = 10749
        case tvMovie = 10770
        case war = 10752
        
        var name: String {
            switch self {
            case .action: return "액션"
            case .animation: return "애니메이션"
            case .crime: return "범죄"
            case .drama: return "드라마"
            case .fantasy: return "판타지"
            case .horror: return "공포"
            case .mystery: return "미스터리"
            case .sf: return "SF"
            case .thriller: return "스릴러"
            case .west: return "서부"
            case .adventure: return "모험"
            case .comedy: return "코미디"
            case .documentary: return "다큐멘터리"
            case .family: return "가족"
            case .history: return "역사"
            case .music: return "음악"
            case .romance: return "로맨스"
            case .tvMovie: return "TV 영화"
            case .war: return "전쟁"
            }
        }
    }
}

// MARK: - 설정 메뉴
extension Resource {
    enum Setting: String, CaseIterable {
        case faq = "자주 묻는 질문"
        case inquiry = "1:1 문의"
        case notification = "알림 설정"
        case Withdraw = "탈퇴하기"
    }
}

// MARK: - 네비게이션 타이틀
extension Resource {
    enum NavTitle: String {
        case makeNickname = "프로필 설정"
        case makeProfileImage = "프로필 이미지 설정"
        case main = "Weavie"
        case setting = "설정"
        case editNickname = "프로필 편집"
        case editProfileImage = "프로필 이미지 편집"
        case search = "영화 검색"
        case detail // 영화 제목
        case upcoming = "개봉 예정 영화"
    }
}

// MARK: - Label, Placeholder
extension Resource {
    enum Placeholder: String {
        case nickname = "닉네임을 입력해주세요."
        case searchMovie = "영화를 검색해보세요."
    }
    
    enum LabelText: String {
        case searchRecord = "최근 검색어"
        case todayMovie = "오늘의 영화"
        case synopsis = "Synopsis"
        case cast = "Cast"
        case poster = "Poster"
        case onboarding = """
                            당신만의 영화 세상,
                            Weavie를 시작해보세요.
                            """
    }
}

// MARK: - 탭바
extension Resource {
    enum tabItem: String {
        case cinema = "Cinema"
        case upcoming = "Upcoming"
        case profile = "Profile"
        
        var image: String {
            switch self {
            case .cinema:
                "popcorn"
            case .upcoming:
                "film.stack"
            case .profile:
                "person.crop.circle"
            }
        }
    }
}
