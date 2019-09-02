// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stops = try? newJSONDecoder().decode(Stops.self, from: jsonData)

import Foundation

// MARK: - Stops
class Song: Codable {
    let author, moderator, performer: String?
    let tags: [String]
    let tagsAsCode, tagsAsString, title: String
    let version: Int
    let chordShifter: ChordShifter
    let lineNum: [String]
    let metaData: MetaData
    let sequence: [Bool]
    let songChords, songText, refrenChordsAsString, refrenText: String
    let zwrotkiElement: [ZwrotkiElement]
    let fileName: String
    let link: String?
    let simpleTags: [String]
    let official: Bool
    
    init(author: String, moderator: String, performer: String, tags: [String], tagsAsCode: String, tagsAsString: String, title: String, version: Int, chordShifter: ChordShifter, lineNum: [String], metaData: MetaData, sequence: [Bool], songChords: String, songText: String, refrenChordsAsString: String, refrenText: String, zwrotkiElement: [ZwrotkiElement], fileName: String, link: String, simpleTags: [String], official: Bool) {
        self.author = author
        self.moderator = moderator
        self.performer = performer
        self.tags = tags
        self.tagsAsCode = tagsAsCode
        self.tagsAsString = tagsAsString
        self.title = title
        self.version = version
        self.chordShifter = chordShifter
        self.lineNum = lineNum
        self.metaData = metaData
        self.sequence = sequence
        self.songChords = songChords
        self.songText = songText
        self.refrenChordsAsString = refrenChordsAsString
        self.refrenText = refrenText
        self.zwrotkiElement = zwrotkiElement
        self.fileName = fileName
        self.link = link
        self.simpleTags = simpleTags
        self.official = official
    }
}

// MARK: - ChordShifter
class ChordShifter: Codable {
    let chordList: [ChordList]
    let separatorList: [SeparatorList]
    let shift: Int
    
    init(chordList: [ChordList], separatorList: [SeparatorList], shift: Int) {
        self.chordList = chordList
        self.separatorList = separatorList
        self.shift = shift
    }
}

// MARK: - ChordList
class ChordList: Codable {
    let chord: Int
    let isDur: Bool
    
    init(chord: Int, isDur: Bool) {
        self.chord = chord
        self.isDur = isDur
    }
}

enum SeparatorList: String, Codable {
    case empty = " "
    case purple = "\n\n"
    case separatorList = "\n"
}

// MARK: - MetaData
class MetaData: Codable {
    let fileName: String
    let textSizeHorizontal: [Int]
    let textSizeVertical: [Double]
    
    init(fileName: String, textSizeHorizontal: [Int], textSizeVertical: [Double]) {
        self.fileName = fileName
        self.textSizeHorizontal = textSizeHorizontal
        self.textSizeVertical = textSizeVertical
    }
}

// MARK: - ZwrotkiElement
class ZwrotkiElement: Codable {
    let chords: String
    
    init(chords: String) {
        self.chords = chords
    }
}
