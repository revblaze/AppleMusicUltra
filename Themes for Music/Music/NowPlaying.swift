//
//  Player.swift
//  Themes for Music
//
//  Created by Justin Bush on 2020-03-30.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import AppKit
import Foundation

protocol Playable {
    func getArtwork()
    func getArtistArtwork()
    func setArtwork(_ image: String)
    func setNowPlaying(_ data: [String])
}

struct Playing {
    static var song   = Item()
    static var album  = Item()
    static var artist = Item()
    static var plist  = Item()
    
    struct Item {
        var name = ""
        var url  = ""
        var img  = ""
        // Optionals
        var artist = ""
        var album  = ""
        // DEBUG: MusicType as String (song, album, artist, plist)
        var type = ""
    }
    
    static func stringToType(_ type: String) -> Playing.Item {
        switch type {
        case MusicType.song.name: return MusicType.song.item
        case MusicType.album.name: return MusicType.album.item
        case MusicType.artist.name: return MusicType.artist.item
        case MusicType.plist.name: return MusicType.plist.item
        default: return MusicType.plist.item
        }
    }
}

enum MusicType {
    case song
    case artist
    case album
    case plist
    
    var item: Playing.Item {
        switch self {
        case .song:   return Playing.song
        case .artist: return Playing.artist
        case .album:  return Playing.album
        case .plist:  return Playing.plist
        }
    }
    
    var name: String {
        switch self {
        case .song:   return "Song"
        case .artist: return "Artist"
        case .album:  return "Album"
        case .plist:  return "Playing"
        }
    }
}

class NowPlaying {
    
    func updateSong(name: String, artist: String, album: String) {
        Playing.song.name = name
        //Playing.song.url  = url
        Playing.song.artist = artist
        Playing.song.album = album
        Playing.song.type = "Song"
    }
    
    func updateAlbum(name: String, url: String, img: String) {
        Playing.album.name = name
        Playing.album.url  = url
        Playing.album.img  = img
        Playing.album.type = "Album"
    }
    
    func updateArtist(name: String, url: String, img: String) {
        Playing.artist.name = name
        Playing.artist.url  = url
        Playing.artist.img  = img
        Playing.artist.type = "Artist"
    }
    
    func updatePlaylist(name: String, url: String, img: String) {
        var music = Playing.plist
        music.name = name
        music.url  = url
        music.img  = img
        music.type = "Playlist"
        printNowPlaying(music)
    }
    
    
    // NEW UNIVERSAL HANDLER
    
    func updatePlaying(_ type: Playing.Item, img: String) {
        var music = type
        music.img = img
        printNowPlaying(music)
    }
    
    func updatePlaying(_ type: Playing.Item, name: String, url: String) {
        var music = type
        music.name = name
        music.url  = url
        printNowPlaying(music)
    }
    
    
    func updatePlaying(_ type: Playing.Item, name: String, url: String, img: String) {
        var music = type
        music.name = name
        music.url  = url
        music.img  = img
        printNowPlaying(music)
    }
    
    func printNowPlaying(_ item: Playing.Item) {
        print("NowPlaying: \(item.type)\n  name: \(item.name)\n   url: \(item.url)\n   img: \(item.img)")
    }
    
}


