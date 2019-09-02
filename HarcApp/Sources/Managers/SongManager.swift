//
//  SongManager.swift
//  HarcApp
//
//  Created by Marcin Slusarek on 02/09/2019.
//  Copyright © 2019 Marcin Slusarek. All rights reserved.
//

import UIKit

class SongManager {
    
    private static var sharedSongManager: SongManager = {
        
        var songs: [Song] = []
        let files = Bundle.main.paths(forResourcesOfType: "", inDirectory: nil)
        print(files.count)
        for var file in files {
            file = String(file.split(separator: "/").last ?? "")
            if let filepath = Bundle.main.path(forResource: file, ofType: "") {
                do {
                    let contents = try String(contentsOfFile: filepath)
                    let song = try? JSONDecoder().decode(Song.self, from: contents.data(using: .utf8) ?? Data())
                    
                    if let song = song {
                        songs.append(song)
                    }
                } catch {
                    print("catch")
                }
            } else {
                print("not found")
            }
        }
        
        let polish = Locale(identifier: "pl")
        songs.sort(by: { $0.title.compare($1.title, locale: polish) == .orderedAscending })
        let songManager = SongManager(songs: songs)
        
        return songManager
    }()
    
    let songs: [Song]
    
    private init(songs: [Song]) {
        self.songs = songs
    }
    
    class func shared() -> SongManager {
        return sharedSongManager
    }
}

