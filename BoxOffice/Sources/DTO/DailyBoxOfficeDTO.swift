//
//  DailyBoxOfficeDTO.swift
//  BoxOffice
//
//  Created by Roh on 2/13/24.
//

import Foundation

struct DailyBoxOfficeDTO: Decodable {
    let boxOfficeResult: BoxOfficeResult
    
    struct BoxOfficeResult: Decodable {
        let boxofficeType, showRange: String
        let dailyBoxOfficeList: [DailyBoxOfficeList]
        
        struct DailyBoxOfficeList: Decodable {
            let rnum, rank, rankInten: String
            let rankOldAndNew: RankOldAndNew
            let movieCD, movieNm, openDt, salesAmt: String
            let salesShare, salesInten, salesChange, salesAcc: String
            let audiCnt, audiInten, audiChange, audiAcc: String
            let scrnCnt, showCnt: String

            enum CodingKeys: String, CodingKey {
                case rnum, rank, rankInten, rankOldAndNew
                case movieCD = "movieCd"
                case movieNm, openDt, salesAmt, salesShare, salesInten, salesChange, salesAcc, audiCnt, audiInten, audiChange, audiAcc, scrnCnt, showCnt
            }
        }
    }
    
    enum RankOldAndNew: String, Decodable {
        case new = "NEW"
        case old = "OLD"
    }
}





