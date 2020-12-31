//
//  WebError.swift
//  WebBrowser
//
//  Created by Wonhee on 2020/12/31.
//

import Foundation

enum WebError: Error {
    case converUrl
    case moveForward
    case moveBack
    case loadPage
    case emptyAddress
    case validateAddress
    case unknow
}

extension WebError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .converUrl:
            return "url로 변환하는데 문제가 있습니다."
        case .moveForward:
            return "앞으로 이동할 페이지가 없습니다."
        case .moveBack:
            return "뒤로 이동할 페이지가 없습니다."
        case .loadPage:
            return "페이지를 새로고침하는데 실패했습니다."
        case .emptyAddress:
            return "이동하고 싶은 URL을 입력해주세요."
        case .validateAddress:
            return "입력한 주소가 올바른 형태가 아닙니다."
        case .unknow:
            return "알수 없는 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        }
    }
}
