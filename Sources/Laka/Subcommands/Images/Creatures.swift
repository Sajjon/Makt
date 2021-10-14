//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation

import ArgumentParser
import Guld
import Malm
import Util

extension Laka {
    
    /// A command to extract in combat sprites of creatures, but not on map monster icons.
    struct Creatures: ParsableCommand, TextureGenerating {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract in combat sprites of creatures, but not on map monster icons."
        )
        
        @OptionGroup var parentOptions: Options
    }
}

// MARK: Run
extension Laka.Creatures {
    
    mutating func run() throws {
        print(
            """
            
            🔮
            About to extract all animiations for all creatures in town original game, from entries exported by the `Laka LOD` command.
            Located at: \(inDataURL.path)
            To folder: \(outImagesURL.path)
            This will take about 1 minute and 10 seconds on a fast machine (Macbook Pro 2019 - Intel CPU)
            ☕️
            
            """
        )
        
        try exportGraphics()
    }
}

extension Laka.Creatures {
    var verbose: Bool { parentOptions.printDebugInformation }
    
    var inDataURL: URL {
        .init(fileURLWithPath: parentOptions.outputPath).appendingPathComponent("Raw")
    }
    
    var outImagesURL: URL {
        .init(fileURLWithPath: parentOptions.outputPath)
        .appendingPathComponent("Converted")
        .appendingPathComponent("Creatures")
    }
}

private extension Laka.Creatures {
    func exportGraphics() throws {
        var progressBar = ProgressBar()
        func extractGraphics(faction: Faction, defList: [String]) throws {
            print("✨ Extracting graphics for all creatures from faction: \(faction.name)")
            let creaturesOfFaction = Creature.ID.of(faction: faction)
            
            assert(creaturesOfFaction.count == defList.count)
            
            let pairList = zip(
                creaturesOfFaction,
                defList.map { $0.lowercased() }
            )
            
            let factionURL = outImagesURL.appendingPathComponent(faction.name, isDirectory: true)
            try fileManager.createDirectory(at: factionURL, withIntermediateDirectories: true)
            
            
            let defParser = DefParser()
            var count = 0
            let total = creaturesOfFaction.count
            try pairList.sorted(by: { $0.0.rawValue < $1.0.rawValue }).forEach { (creatureID, defFilename) in
                guard let defFileData = fileManager.contents(atPath: inDataURL.appendingPathComponent(defFilename).path) else {
                    throw Fail(description: "Failed to find file: \(defFilename)")
                }
                let defFile = try defParser.parse(data: defFileData, definitionFileName: defFilename)
                let palette = defFile.palette
                var exportedUniqueBlocks = Set<Block.OnlyContent>()
                //print("\(creatureID.name) has #\(defFile.blocks.count) of which #\(Set(defFile.blocks.map { $0.onlyContent }).count) are unique")
                
                let creatureURL = factionURL.appendingPathComponent(creatureID.name, isDirectory: true)
                try fileManager.createDirectory(at: creatureURL, withIntermediateDirectories: true)
                
                
                for (blockIndex, block) in defFile.blocks.enumerated() {
                    let blockContent = block.onlyContent
                    guard !exportedUniqueBlocks.contains(blockContent) else {
                       continue
                    }
                    defer { exportedUniqueBlocks.insert(blockContent) }
                    
                    let imageAtlasAggregator = makeAggregator(atlasName: "\(creatureID.name)_block\(blockIndex)")
                    
                    var exportedUniqueFrame = Set<OnlyContentFrame>()
                    var nameOfAddedFrames = [String]()
                    let imagesInBlock: [ImageFromFrame] = try block.frames.enumerated().compactMap({ frameIndex, frame in
                        let frameContent = frame.onlyContent
                        guard !exportedUniqueFrame.contains(frameContent) else {
                            return nil
                        }
                        defer {
                            exportedUniqueFrame.insert(frameContent)
                            nameOfAddedFrames.append(frame.fileName)
                            
                        }
                        let cgImage = try ImageImporter.imageFrom(frame: frame, palette: palette)
                        return ImageFromFrame(frame: frame, cgImage: cgImage)
                    })
                    
                    let aggregatedFiles = try imageAtlasAggregator.aggregate(files: imagesInBlock)
                    
                    try aggregatedFiles.forEach({ fileToSave in
                    
                        let fileURL = creatureURL
                            .appendingPathComponent(fileToSave.name)
                        
                        try fileToSave.data.write(to: fileURL)
                    })
                }
                count += 1
                progressBar.render(count: count, total: total)
                
            }
        }
        
        
        try extractGraphics(faction: .castle, defList: [
            "CPKMAN.DEF",
            "CHALBD.DEF",
            "CLCBOW.DEF",
            "CHCBOW.DEF",
            "CGRIFF.DEF",
            "CRGRIF.DEF",
            "CSWORD.DEF",
            "CCRUSD.DEF",
            "CMONKK.DEF",
            "CZEALT.DEF",
            "CCAVLR.DEF",
            "CCHAMP.DEF",
            "CANGEL.DEF",
            "CRANGL.DEF"
        ])
        
        try extractGraphics(faction: .conflux, defList: [
            "CAELEM.DEF",
            "CEELEM.DEF",
            "CFELEM.DEF",
            "CWELEM.DEF",
            "CPIXIE.DEF",
            "CSPRITE.DEF",
            "CPSYEL.DEF",
            "CMAGEL.DEF",
            "CICEE.DEF",
            "CSTONE.DEF",
            "CSTORM.DEF",
            "CNRG.DEF",
            "CFBIRD.DEF",
            "CPHX.DEF"
        ])
        
        try extractGraphics(faction: .dungeon, defList: [
            "CTROGL.DEF",
            "CITROG.DEF",
            "CHARPY.DEF",
            "CHARPH.DEF",
            "CBEHOL.DEF",
            "CEVEYE.DEF",
            "CMEDUS.DEF",
            "CMEDUQ.DEF",
            "CMINOT.DEF",
            "CMINOK.DEF",
            "CMCORE.DEF",
            "CCMCOR.DEF",
            "CRDRGN.DEF",
            "CBDRGN.DEF"
        ])
        
        try extractGraphics(faction: .fortress, defList: [
            "CGNOLL.DEF",
            "CGNOLM.DEF",
            "CPLIZA.DEF",
            "CALIZA.DEF",
            "CCGORG.DEF",
            "CBGOG.DEF",
            "CDRFLY.DEF",
            "CDRFIR.DEF",
            "CBASIL.DEF",
            "CGBASI.DEF",
            "CWYVER.DEF",
            "CWYVMN.DEF",
            "CHYDRA.DEF",
            "CCHYDR.DEF"
        ])
        
        try extractGraphics(faction: .inferno, defList: [
            "CIMP.DEF",
            "CFAMIL.DEF",
            "CGOG.DEF",
            "CMAGOG.DEF",
            "CHHOUN.DEF",
            "CCERBU.DEF",
            "COHDEM.DEF",
            "CTHDEM.DEF",
            "CPFIEN.DEF",
            "CPFOE.DEF",
            "CEFREE.DEF",
            "CEFRES.DEF",
            "CDEVIL.DEF",
            "CADEVL.DEF"
        ])
        
        try extractGraphics(faction: .necropolis, defList: [
            "CSKELE.DEF",
            "CWSKEL.DEF",
            "CZOMBI.DEF",
            "CZOMLO.DEF",
            "CWIGHT.DEF",
            "CWRAIT.DEF",
            "CVAMP.DEF",
            "CNOSFE.DEF",
            "CLICH.DEF",
            "CPLICH.DEF",
            "CBKNIG.DEF",
            "CBLORD.DEF",
            "CNDRGN.DEF",
            "CHDRGN.DEF"
        ])
        
        try extractGraphics(faction: .rampart, defList: [
            "CCENTR.DEF",
            "CECENT.DEF",
            "CDWARF.DEF",
            "CBDWAR.DEF",
            "CELF.DEF",
            "CGRELF.DEF",
            "CPEGAS.DEF",
            "CAPEGS.DEF",
            "CTREE.DEF",
            "CBTREE.DEF",
            "CUNICO.DEF",
            "CWUNIC.DEF",
            "CGDRAG.DEF",
            "CDDRAG.DEF"
        ])
        
        try extractGraphics(faction: .stronghold, defList: [
            "CGOBLI.DEF",
            "CHGOBL.DEF",
            "CBWLFR.DEF",
            "CUWLFR.DEF",
            "CORC.DEF",
            "CORCCH.DEF",
            "COGRE.DEF",
            "COGMAG.DEF",
            "CROC.DEF",
            "CTBIRD.DEF",
            "CCYCLR.DEF",
            "CCYCLLOR.DEF",
            "CYBEHE.DEF",
            "CABEHE.DEF"
        ])
        
        try extractGraphics(faction: .tower, defList: [
            "CGREMA.DEF",
            "CGREMM.DEF",
            "CGARGO.DEF",
            "COGARG.DEF",
            "CSGOLE.DEF",
            "CIGOLE.DEF",
            "CMAGE.DEF",
            "CAMAGE.DEF",
            "CGENIE.DEF",
            "CSULTA.DEF",
            "CNAGA.DEF",
            "CNAGAG.DEF",
            "CLTITA.DEF",
            "CGTITA.DEF"
        ])
        
        try extractGraphics(faction: .neutral, defList: [
            "CPEAS.DEF",
            "CHALF.DEF",
            "CBOAR.DEF",
            "CROGUE.DEF",
            "CMUMMY.DEF",
            "CNOMAD.DEF",
            "CTROLL.DEF",
            
            "CGGOLE.DEF",
            "CDGOLE.DEF",
            
            "CSHARP.DEF",
            "Cench.DEF",
            "CFDRGN.DEF",
            "CCDRGN.DEF",
            "CRSDGN.DEF",
            "CADRGN.DEF"
        ])
        

        
    }
}

extension Block {
    struct OnlyContent: Hashable {
        let onlyContentFrames: Set<OnlyContentFrame>
    }
    var onlyContent: OnlyContent {
        .init(onlyContentFrames: Set(self.frames.map { $0.onlyContent }))
    }
    
}

struct OnlyContentFrame: Hashable {
//    let frameName: String
    let pixelDataHash: String
}

import CryptoKit
extension DefinitionFile.Frame {
    var onlyContent: OnlyContentFrame {
        var hasher = SHA256()
        hasher.update(data: pixelData)
        let hash = Data(hasher.finalize())
//        return OnlyContentFrame(frameName: self.fileName, pixelDataHash: hash.hexEncodedString())
//        .init(frameName: self.fileName)
 
        return .init(pixelDataHash: hash.hexEncodedString())
    }
}
