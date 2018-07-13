// 
//  CPYSearchWindowController.swift
//
//  Clipy
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
// 
//  Created by Dmytro Karpovych on 13.07.18.
// 
//  Copyright © 2015-2018 Clipy Project.
//

import Cocoa
import RealmSwift

class CPYSearchWindowController: NSWindowController, NSTextViewDelegate {

    // MARK: - Properties
    @IBOutlet private weak var tableView: NSTableView!
    @IBOutlet private weak var searchField: NSSearchField!

    var clips: Results<CPYClip> = AppEnvironment.current.clipService.getClips()

    static let sharedController = CPYSearchWindowController(windowNibName: NSNib.Name(rawValue: "CPYSearchWindowController"))

    @IBAction private func selectClip(_ sender: NSTableView) {
        let clip = clips[sender.selectedRow]
        AppEnvironment.current.pasteService.paste(with: clip)
        self.close()
    }

    @IBAction private func changeSearchString(_ sender: NSSearchField) {
        var clips = AppEnvironment.current.clipService.getClips()
        let searchText = sender.stringValue
        if !searchText.isEmpty {
            let resultPredicate = NSPredicate(format: "title contains[c] %@", searchText)
            clips = clips.filter(resultPredicate)
        }
        self.clips = clips
        tableView.reloadData()
    }
}

// MARK: - NSTableView DataSource
extension CPYSearchWindowController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return clips.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let clip = clips[row]
        return clip.title.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
