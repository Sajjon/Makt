//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import Malm

extension FileManager {
    
    func createOutputDirectoryIfNeeded(path outputPath: String) throws {
        
        do {
            try createDirectory(atPath: outputPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            let createOutputPathError = Fail(description: "Failed to create output directory at: '\(outputPath)'")
            print("❌ Error: \(String(describing: createOutputPathError))")
            throw createOutputPathError
        }
    }
    
    
    func findFiles(
        extensions targetFileExtensions: Set<String>,
        at urlToSearch: URL,
        failOnEmpty: Bool = true,
        verbose: Bool = false
    ) throws -> [URL] {
        targetFileExtensions.forEach {
            assert($0.lowercased() == $0)
        }
        let resourceKeys = Set<URLResourceKey>([.nameKey, .isDirectoryKey])
        
        var failureToReadFile: Swift.Error?
        guard
            let enumerator = enumerator(
                at: urlToSearch,
                includingPropertiesForKeys: Array(resourceKeys),
                options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles],
                errorHandler: { url, error in
                    failureToReadFile = Fail(description: "Failed to Read file '\(url.path)', error: '\(String(describing: error))'")
                    return false
                })
        else {
            throw Fail(description: "Failed to read contents of directory: '\(urlToSearch.path))'")
        }
        if let failureToReadFile = failureToReadFile {
            throw failureToReadFile
        }
        
        var fileURLs: [URL] = []
        for case let fileURL as URL in enumerator {
            
            guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
                  let isDirectory = resourceValues.isDirectory,
                  let name = resourceValues.name
            else {
                if verbose {
                    print("⚠️ Skipped: '\(fileURL.path)' since failed to retrieve info about it.")
                }
                continue
            }
            
            guard !isDirectory else {
//                if verbose {
//                    print("💡 Skipped: '\(fileURL.path)' since it is a directory.")
//                }
                continue
            }
            
            guard let fileExtensionCased = name.fileExtension else {
//                if verbose {
//                    print("💡 Skipped: '\(fileURL.path)' since we failed to read its fileextension.")
//                }
                continue
            }
            
            guard targetFileExtensions.contains(fileExtensionCased.lowercased()) else {
//                if verbose {
//                    print("💡 Skipped: '\(fileURL.path)' since it is not in our target file extension set.")
//                }
                continue
            }
            
//            if verbose {
//                print("Found relevant file at: \(fileURL.path)")
//            }
            
            fileURLs.append(fileURL)
            
        }
        
        guard !fileURLs.isEmpty, failOnEmpty else {
            throw Fail(description: "Failed to find any lod archives at: '\(urlToSearch))'")
        }
        
        return fileURLs
    }
}

// MARK: Export
extension FileManager {
    
    func export(
        target: ExportTarget,
        at source: URL,
        to destination: URL,
        nameOfWorkflow: String? = nil,
        verbose: Bool = false,
        fileWritingOptions: Data.WritingOptions = .noFileProtection,
        calculateWorkload: ((_ filesToExport: [SimpleFile]) throws -> Int)? = nil,
        exporter: Exporter
    ) throws {

        var stepper = Stepper(totalStepCount: calculateWorkload != nil ? 5 : 4)
        
        
        var exporterProgress = 0
        var exporterWorkload: Int?
        
        var progressBar = ProgressBar()
        
        
        try createOutputDirectoryIfNeeded(path: destination.path)
        
        let targetFileExtensions: [String] = {
            switch target {
            case .anyFileWithExtension(let targetFileExtension): return [targetFileExtension]
            case .specificFileList(let targetFiles): return targetFiles.compactMap { $0.fileExtension }
            }
        }()
        
        stepper.step("🔎 Finding files")
        
        let urlsOfFoundFiles = try findFiles(
            extensions: Set(targetFileExtensions),
            at: source,
            verbose: verbose
        )
        
        let files: [URL] = {
            switch target {
            case .anyFileWithExtension: return urlsOfFoundFiles
            case .specificFileList(let targetFileList):
                let targetFiles = Set(targetFileList)
                return urlsOfFoundFiles.filter { targetFiles.contains($0.lastPathComponent) }
            }
        }()
        
        stepper.step("📖 Reading files")
        
        let filesToExport: [SimpleFile] = try files.map{ file in
            guard let data = contents(atPath: file.path) else {
                throw Fail(description: "failed file at path: \(file.path)")
            }
            return .init(name: file.lastPathComponent, data: data)
        }
        
        
        if let calculateWorkload = calculateWorkload {
            stepper.step("💡 Calculating workload")
            exporterWorkload = try calculateWorkload(filesToExport)
            if verbose {
                print("✨ found workload of #\(exporterWorkload!).")
            }
        }
        
        stepper.start("⚙️  Exporting files", note: "(takes some time)")
        let filesToSave: [SimpleFile] = try filesToExport.flatMap { (toExport: SimpleFile) throws -> [SimpleFile] in
            let exported = try exporter.export(toExport)
            exporterProgress += exported.count
            if let exporterWorkload = exporterWorkload {
                progressBar.render(count: exporterProgress, total: exporterWorkload)
            }
            return exported
        }
        stepper.finishedStep()
        
        stepper.step("💾 Saving files")
        for fileToSave in filesToSave {
            let fileURL = destination.appendingPathComponent(fileToSave.name)
            if verbose {
                print("Writing file: to '\(fileURL.path)' (#\(fileToSave.data.count) bytes)")
            }
            try fileToSave.data.write(to: fileURL, options: fileWritingOptions)
        }
        stepper.done("✨ Done\(nameOfWorkflow.map { " with \($0)" } ?? "")")
    }
}
