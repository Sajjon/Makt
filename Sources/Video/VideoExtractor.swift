//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-20.
//

import Foundation
//import SwiftFFmpeg
import AVFoundation
import Combine
import Common
import Guld


public final class VideoExtractor {
    public init() {}
}

public extension VideoExtractor {
    
    enum Error: Swift.Error {
        public enum OpenVideoError: Swift.Error, Equatable {
            case failedToGetVideoStreamFromContext
            case codecNotFound(String)
        }
        case openVideoError(OpenVideoError)
        public enum InitExtractionError: Swift.Error, Equatable {
            case failedToCreateAVAssetWriter
        }
        case initExtractionError(InitExtractionError)
        case extractionFinishError(Swift.Error)
    }
    
    static let fileExtension: String = "mov"
    
    func extract(
        data dataForWholeVideo: Data,
        name: String,
        temporaryDirectory: URL,
        outputDirectory: URL
    ) -> AnyPublisher<URL, VideoExtractor.Error> {
        fatalError()
        /*
        let tmpDataURL = temporaryDirectory.appendingPathComponent("tmp_data_safe_to_delete")
        let tmpImageURL = temporaryDirectory.appendingPathComponent("tmp_image_safe_to_delete.png")
        let outputURL = outputDirectory.appendingPathComponent([name, VideoExtractor.fileExtension].joined(separator: "."))
        
        func removeTempFiles() {
            try? FileManager.default.removeItem(atPath: temporaryDirectory.path)
        }
        
        return Future<URL, VideoExtractor.Error> { promise in
            DispatchQueue(label: "ExtractVideo", qos: .background).async {
                do {
                    try dataForWholeVideo.write(to: tmpDataURL)
                    
                    let formatContext = try AVFormatContext(
                        url: tmpDataURL.path,
                        format: nil,
                        options: nil
                    )
                    
                    try formatContext.findStreamInfo()
                    
                    formatContext.dumpFormat(isOutput: false)

                    
                    guard let stream = formatContext.videoStream else {
                        throw Error.openVideoError(.failedToGetVideoStreamFromContext)
                    }
                    
                    guard let codec = AVCodec.findDecoderById(stream.codecParameters.codecId) else {
                        throw Error.openVideoError(.codecNotFound(stream.codecParameters.codecId.name))
                    }
                    let codecContext = AVCodecContext(codec: codec)
                    codecContext.setParameters(stream.codecParameters)
                    
                    try codecContext.openCodec()
                    
                    let packet = AVPacket()
                    let frame = AVFrame()
                    
                    let videoWriter: AVAssetWriter
                    do {
                        videoWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mov)
                    } catch {
                        throw Error.initExtractionError(.failedToCreateAVAssetWriter)
                    }
                    
                    let outputSettings: [String: Any] = [
                        AVFoundation.AVVideoCodecKey: AVFoundation.AVVideoCodecType.jpeg,
                        AVFoundation.AVVideoWidthKey: NSNumber.init(value: codecContext.width),
                        AVFoundation.AVVideoHeightKey: NSNumber.init(value: codecContext.height)
                    ]
                    
                    let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings, sourceFormatHint: nil)
                    
                    
                    let sourcePixelBufferAttributes: [String: Any] = [
                        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_24RGB,
                        kCVPixelBufferCGImageCompatibilityKey as String: true,
                        kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
                    ]
                    
                    let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
                        assetWriterInput: writerInput,
                        sourcePixelBufferAttributes: sourcePixelBufferAttributes
                    )
                    
                    assert(videoWriter.canAdd(writerInput))
                    videoWriter.add(writerInput)
                    
                    videoWriter.startWriting()
                    videoWriter.startSession(atSourceTime: CMTime.zero)
                    
                    while true {
                        
                        do {
                            let _ = try formatContext.readFrame(into: packet)
                        } catch let error as SwiftFFmpeg.AVError {
                            if error == .eof {
                                break
                            } else {
                                fatalError("⚠️ Failed to read frame, error: \(error)")
                            }
                        }
                        
                        defer { packet.unref() }
                        
                        if packet.streamIndex != stream.index {
                            continue
                        }
                        
                        guard stream.mediaType == .video else {
                            continue
                        }
                        
                        try codecContext.sendPacket(packet)
                        
                        while true {
                            do {
                                try codecContext.receiveFrame(frame)
                            } catch let err as SwiftFFmpeg.AVError where err == .tryAgain || err == .eof {
                                break
                            }
                            
                            let pixelBufferAttributes: [String: Any] = [
                                kCVPixelBufferCGImageCompatibilityKey as String: true,
                                kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
                            ]
                            
                            func pixelFormat() -> OSType {
                                switch frame.pixelFormat {
                                case .YUV420P: return kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
                                case .PAL8:
                                    return kCVPixelFormatType_32ARGB
                                default: fatalError("handle format: \(String(describing: frame.pixelFormat))")
                                }
                            }
                            
                            var cvPixelBuffer: CVPixelBuffer!
                            let createBufferResult = CVPixelBufferCreate(
                                kCFAllocatorDefault,
                                frame.width,
                                frame.height,
                                pixelFormat(),
                                pixelBufferAttributes as CFDictionary,
                                &cvPixelBuffer
                            )
                            guard createBufferResult == kCVReturnSuccess else {
                                fatalError("failed to create cvPixelBuffer, createBufferResult: \(createBufferResult)")
                            }
                            try self.savePNG(frame, to: tmpImageURL.path)
                            guard let ciImage = CIImage(contentsOf: tmpImageURL) else {
                                fatalError("failed to load image at url")
                            }
                            
                            let ciContext = CIContext()
                            ciContext.render(ciImage, to: cvPixelBuffer)
      
                            pixelBufferAdaptor.append(
                                cvPixelBuffer,
                                withPresentationTime: CMTime.init(value: frame.bestEffortTimestamp, timescale: .init(stream.realFramerate.toDouble))
                            )
                            
                            frame.unref()
                        }
                    }
                    
                    writerInput.markAsFinished()
                    videoWriter.finishWriting {
                        removeTempFiles()
                        if let error = videoWriter.error {
                            promise(.failure(VideoExtractor.Error.extractionFinishError(error)))
                        } else {
                            promise(.success(outputURL))
                        }
                    }
                }
                catch let error as VideoExtractor.Error {
                    removeTempFiles()
                    promise(.failure(error))
                } catch {
                    removeTempFiles()
                    uncaught(error: error)
                }
            }
        }.eraseToAnyPublisher()
         */
    }
}

/*

private extension VideoExtractor {
    
    func savePNG(_ frame: AVFrame, to url: String) throws {
        let fmtCtx = try AVFormatContext(format: nil, filename: url)
        
        guard let codec = AVCodec.findEncoderById(.PNG) else {
            fatalError("png codec doesn't exist")
        }
        let codecCtx = AVCodecContext(codec: codec)
        codecCtx.width = frame.width
        codecCtx.height = frame.height
        codecCtx.pixelFormat = .RGB24
        codecCtx.timebase = AVRational(num: 1, den: 1)
        codecCtx.framerate = AVRational(num: 0, den: 1)
        try codecCtx.openCodec()
        guard let stream = fmtCtx.addStream(codec: codec) else {
            fatalError("Failed allocating output stream")
        }
        stream.codecParameters.copy(from: codecCtx)
        
        if fmtCtx.outputFormat?.flags.contains(.noFile) == false {
            try fmtCtx.openOutput(url: url, flags: .write)
        }
        
        
        try fmtCtx.writeHeader()
        
        let dstPkt = AVPacket()
        let dstFrame = AVFrame()
        dstFrame.width = codecCtx.width
        dstFrame.height = codecCtx.height
        dstFrame.pixelFormat = codecCtx.pixelFormat
        
        let swsCtx = SwsContext(
            srcWidth: frame.width,
            srcHeight: frame.height,
            srcPixelFormat: frame.pixelFormat,
            dstWidth: dstFrame.width,
            dstHeight: dstFrame.height,
            dstPixelFormat: dstFrame.pixelFormat,
            flags: .bilinear
        )!
        let srcSlice = frame.data.map({ UnsafePointer($0) })
        let srcStride = frame.linesize.map({ Int32($0) })
        
        let dstBuf = AVImage.init(width: dstFrame.width, height: dstFrame.height, pixelFormat: dstFrame.pixelFormat, align: 1)
        
        try swsCtx.scale(
            src: srcSlice,
            srcStride: srcStride,
            srcSliceY: 0,
            srcSliceHeight: frame.height,
            dst: dstBuf.data.map { UnsafeMutablePointer($0) },
            dstStride: dstBuf.linesizes.map { $0 }
        )
        
        var dataSingleFrame = Data()
        for (frameDataIndex, maybeFrameData) in dstBuf.data.enumerated() {
            guard let frameData = maybeFrameData else {
                break
            }
            let byteCount = Int(dstBuf.linesizes[frameDataIndex])
            let singleFramePartData = Data(bytesNoCopy: .init(frameData), count: byteCount, deallocator: .none)
            dataSingleFrame.append(contentsOf: singleFramePartData)
        }
        
        dstFrame.data = dstBuf.data
        dstFrame.linesize = dstBuf.linesizes
        
        do {
            try codecCtx.sendFrame(dstFrame)
        } catch {
            fatalError("Error while sending a packet to the decoder: \(error)")
        }
        
        while true {
            do {
                try codecCtx.receivePacket(dstPkt)
            } catch let err as SwiftFFmpeg.AVError where err == .tryAgain || err == .eof {
                break
            } catch {
                fatalError("Error while receiving a packet from the encoder: \(error)")
            }
            
            dstPkt.streamIndex = 0
            dstPkt.pts = AVTimestamp.noPTS
            dstPkt.dts = AVTimestamp.noPTS
            dstPkt.duration = 0
            dstPkt.position = -1
            try fmtCtx.interleavedWriteFrame(dstPkt)
            dstPkt.unref()
        }
        dstFrame.unref()
        
        try fmtCtx.writeTrailer()
    }
}

*/
