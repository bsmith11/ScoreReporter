//
//  APIConstants.swift
//  ScoreReporterCore
//
//  Created by Bradley Smith on 11/23/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

struct APIConstants {
    struct Path {
        static let baseURL = "https://play.usaultimate.org/"

        struct Keys {
            static let function = "f"
        }

        struct Values {
            static let login = "MemberLogin"
            static let events = "GETALLEVENTS"
            static let eventDetails = "GETGAMESBYEVENT"
            static let teams = "GetTeams"
            static let teamDetails = "GetGamesByTeam"
            static let updateGame = "UpdateGameStatus"
        }
    }

    struct Request {
        struct Keys {
            static let username = "username"
            static let password = "password"
            static let eventID = "EventId"
            static let teamID = "TeamId"
            static let gameID = "GameId"
            static let homeScore = "HomeScore"
            static let awayScore = "AwayScore"
            static let gameStatus = "GameStatus"
            static let userToken = "UserToken"
        }
    }

    struct Response {
        struct Keys {
            static let success = "success"
            static let message = "message"
            static let error = "error"
            static let userToken = "UserToken"
            static let events = "Events"
            static let groups = "EventGroups"
            static let teams = "Teams"

            static let eventID = "EventId"
            static let eventName = "EventName"
            static let eventType = "EventType"
            static let city = "City"
            static let state = "State"
            static let startDate = "StartDate"
            static let endDate = "EndDate"
            static let eventLogo = "EventLogo"
            static let competitionGroup = "CompetitionGroup"

            static let groupID = "EventGroupId"
            static let divisionName = "DivisionName"
            static let teamCount = "TeamCount"
            static let groupName = "GroupName"
            static let eventGroupName = "EventGroupName"
            static let eventRounds = "EventRounds"

            static let roundID = "RoundId"
            static let brackets = "Brackets"
            static let clusters = "Clusters"
            static let pools = "Pools"

            static let bracketID = "BracketId"
            static let bracketName = "BracketName"
            static let stage = "Stage"

            static let stageID = "StageId"
            static let stageName = "StageName"
            static let games = "Games"

            static let clusterID = "ClusterId"
            static let name = "Name"

            static let poolID = "PoolId"
            static let standings = "Standings"

            static let gameID = "EventGameId"
            static let homeTeamName = "HomeTeamName"
            static let homeTeamScore = "HomeTeamScore"
            static let awayTeamName = "AwayTeamName"
            static let awayTeamScore = "AwayTeamScore"
            static let fieldName = "FieldName"
            static let gameStatus = "GameStatus"
            static let startTime = "StartTime"

            static let wins = "Wins"
            static let losses = "Losses"
            static let sortOrder = "SortOrder"
            static let teamName = "TeamName"

            static let teamID = "TeamId"
            static let teamLogo = "TeamLogo"
            static let schoolName = "SchoolName"
            static let competitionLevel = "CompetitionLevel"
            static let teamDesignation = "TeamDesignation"

            static let memberID = "MemberId"
            static let accountID = "AccountId"
            
            static let updatedGameRecord = "Updated GameRecord"
        }

        struct Values {
            static let tournament = "Tournament"
            static let inProgress = "In Progress"
        }
    }
}
