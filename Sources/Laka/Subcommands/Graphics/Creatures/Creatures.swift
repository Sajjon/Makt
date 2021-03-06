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
import Common

extension Laka {
    
    /// A command to extract in combat sprites of creatures, but not on map monster icons.
    struct Creatures: CMD, TextureGenerating {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract in combat sprites of creatures, but not on map monster icons."
        )
        
        @OptionGroup var options: Options
        
        static let executionOneLinerDescription = "🐉 Extracting creature sprites/animations"
        static let optimisticEstimatedRunTime: TimeInterval = 70
        
        
        /// Requires `Laka lod` to have been run first.
        func extract() throws {
            try exportGraphics()
        }
    }
}

// MARK: Private
private extension Laka.Creatures {
    
    func exportGraphics() throws {
        let factions = Faction.allCases.all(but: [.random])
        try factions.forEach {
            try extractGraphics(faction: $0)
        }
    }
    
    func extractGraphics(faction: Faction) throws {
        let defList = faction.creatureDefFiles
        logger.debug("✨ Extracting graphics for all creatures from faction: \(faction.name)")
        let creaturesOfFaction = Creature.ID.of(faction: faction)
        
        assert(creaturesOfFaction.count == defList.count)
        
        let pairList = zip(
            creaturesOfFaction,
            defList.map { $0.lowercased() }
        )
        
        let factionURL = outImagesURL.appendingPathComponent(faction.name, isDirectory: true)
        try fileManager.createDirectory(at: factionURL, withIntermediateDirectories: true)
        
        
        let defParser = DefParser()
        
        try pairList.sorted(by: { $0.0.rawValue < $1.0.rawValue }).forEach { (creatureID, defFilename) in
            guard let defFileData = fileManager.contents(atPath: inDataURL.appendingPathComponent(defFilename).path) else {
                throw Fail(description: "Failed to find file: \(defFilename)")
            }
            let defFile = try defParser.parse(data: defFileData, definitionFileName: defFilename)
            let palette = defFile.palette
            var exportedUniqueBlocks = Set<Block.OnlyContent>()
            //logger.debug("\(creatureID.name) has #\(defFile.blocks.count) of which #\(Set(defFile.blocks.map { $0.onlyContent }).count) are unique")
            
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
            
        }
    }
    
}

private extension Faction {
    var creatureDefFiles: [String] {
        switch self {
        case .random: incorrectImplementation(reason: "Random is not an existantial faction") // TODO treat random differently?
            
        case .castle: return [
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
            ]
            
        case .conflux: return [
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
            ]
            
        case .dungeon: return [
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
            ]
            
        case .fortress: return [
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
            ]
            
        case .inferno: return [
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
            ]
            
        case .necropolis: return [
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
            ]
            
        case .rampart: return [
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
            ]
            
        case .stronghold: return [
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
            ]
            
        case .tower: return [
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
            ]
            
        case .neutral: return [
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
            ]
        }
    }
}


// MARK: Computed Props
extension Laka.Creatures {
    
    var inDataURL: URL {
        .init(fileURLWithPath: options.outputPath).appendingPathComponent("Raw")
    }
    
    var outImagesURL: URL {
        .init(fileURLWithPath: options.outputPath)
        .appendingPathComponent("Converted")
        .appendingPathComponent("Graphics")
        .appendingPathComponent("Creatures")
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
        return .init(pixelDataHash: hash.hexEncodedString())
    }
}
