//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import Malm
import Common

extension FileManager {
    
    func createOutputDirectoryIfNeeded(path outputPath: String) throws {
        
        do {
            try createDirectory(atPath: outputPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            let createOutputPathError = Fail(description: "Failed to create output directory at: '\(outputPath)'")
            logger.debug("❌ Error: \(String(describing: createOutputPathError))")
            throw createOutputPathError
        }
    }
    
    
    func findFiles(
        extensions targetFileExtensions: Set<String>,
        at urlToSearch: URL,
        failOnEmpty: Bool = true
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
                logger.debug("⚠️ Skipped: '\(fileURL.path)' since failed to retrieve info about it.")
                continue
            }
            
            guard !isDirectory else {
                logger.trace("💡 Skipped: '\(fileURL.path)' since it is a directory.")
                continue
            }
            
            guard let fileExtensionCased = name.fileExtension else {
                logger.trace("💡 Skipped: '\(fileURL.path)' since we failed to read its fileextension.")
                continue
            }
            
            guard targetFileExtensions.contains(fileExtensionCased.lowercased()) else {
                logger.trace("💡 Skipped: '\(fileURL.path)' since it is not in our target file extension set.")
                continue
            }
            
            logger.trace("Found relevant file at: \(fileURL.path)")
            
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
    
    func export<Output: File>(
        target: ExportTarget,
        at source: URL,
        to destination: URL,
        nameOfWorkflow: String? = nil,
        fileWritingOptions: Data.WritingOptions = .noFileProtection,
        filesToExportHaveBeenRead: ((_ filesToExport: [SimpleFile]) throws -> Int)? = nil,
        finishedExportingOneEntry: (() -> Void)? = nil,
        exporter: Exporter<Output>,
        aggregator: Aggregator<Output>? = nil
    ) throws {

        var totalStepCount = 4
        if aggregator != nil {
            totalStepCount += 1
        }
        
        var stepper = Stepper(totalStepCount: totalStepCount, logLevel: .info)
        
        try createOutputDirectoryIfNeeded(path: destination.path)
        
        let targetFileExtensions: [String] = {
            switch target {
            case .allFilesMatchingAnyOfExtensions(let targetFileExtension): return targetFileExtension
            case .specificFileList(let targetFiles): return targetFiles.compactMap { $0.fileExtension }
            }
        }()
      
        stepper.step("🔎 Finding files")
        
        let urlsOfFoundFiles = try findFiles(
            extensions: Set(targetFileExtensions),
            at: source
        )
        
        let files: [URL] = {
            guard case .specificFileList(let targetFileList) = target else {
                return urlsOfFoundFiles
            }
            
            let targetFiles = Set(targetFileList)
            return urlsOfFoundFiles.filter { targetFiles.contains($0.lastPathComponent) }
            
        }()
        
        guard !files.isEmpty else {
            throw Fail(description: "Failed to find any files for target: \(String(describing: target))")
        }
        
        stepper.step("📖 Reading files")
        
        let filesRead: [SimpleFile] = try files.map{ file in
            guard let data = contents(atPath: file.path) else {
                throw Fail(description: "failed file at path: \(file.path)")
            }
            return .init(name: file.lastPathComponent, data: data)
        }
        
        if let filesToExportHaveBeenRead = filesToExportHaveBeenRead {
            _ = try filesToExportHaveBeenRead(filesRead)
        }
        
        stepper.start("⚙️ Exporting files", note: "(takes some time)")
        let exportedFiles: [Output] = try filesRead.flatMap { (toExport: File) throws -> [Output] in
            defer { finishedExportingOneEntry?() }
            return try exporter.export(toExport)
        }
        stepper.finishedStep()
        
        let filesToSave: [File]
        if let aggregator = aggregator {
            stepper.step("💡 Aggregating files")
            let aggregatedFiles = try aggregator.aggregate(files: exportedFiles)
            filesToSave = aggregatedFiles
        } else {
            filesToSave = exportedFiles
        }
        
        stepper.step("💾 Saving files")
        for fileToSave in filesToSave {
            let fileURL = destination.appendingPathComponent(fileToSave.name)
            logger.debug("Writing file: to '\(fileURL.path)' (#\(fileToSave.data.count) bytes)")
            try fileToSave.data.write(to: fileURL, options: fileWritingOptions)
        }
        stepper.done("✨ Done\(nameOfWorkflow.map { " with \($0)" } ?? "")")
    }
}
