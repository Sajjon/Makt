//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-20.
//

import Foundation
import SwiftFFmpeg
import AVFoundation
import Combine
import Util
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
    
    func extract(
        data dataForWholeVideo: Data,
        name: String,
        outputURL maybeOutputURL: URL? = nil
    ) -> AnyPublisher<URL, VideoExtractor.Error> {
        return Future<URL, VideoExtractor.Error> { promise in
            DispatchQueue(label: "Extract video", qos: .background).async {
                do {
                    let directory = try FileManager.default.url(
                        for: .trashDirectory,
                           in: .userDomainMask,
                           appropriateFor: nil,
                           create: false
                    )
                    
                    let fileURL = directory.appendingPathComponent(name)
                    let outputURL = maybeOutputURL ?? directory.appendingPathComponent("\(name).mov")
                    let tmpOutputURL = directory.appendingPathComponent("tmp.png")
                    try dataForWholeVideo.write(to: fileURL)
                    
                    print("Trying to create AVFormatContext with video file: `\(fileURL.absoluteString)`")
                    
                    let fmtCtx = try AVFormatContext(
                        url: fileURL.absoluteString,
                        format: nil,
                        options: nil
                    )
                    
                    try fmtCtx.findStreamInfo()
                    
                    fmtCtx.dumpFormat(isOutput: false)
                    
                    guard let stream = fmtCtx.videoStream else {
                        throw Error.openVideoError(.failedToGetVideoStreamFromContext)
                    }
                    print("Stream - codecParameters: \(stream.codecParameters), metadata: \(stream.metadata), mediaType: \(stream.mediaType), duration: \(stream.duration)")
                    
                    guard let codec = AVCodec.findDecoderById(stream.codecParameters.codecId) else {
                        throw Error.openVideoError(.codecNotFound(stream.codecParameters.codecId.name))
                    }
                    let codecCtx = AVCodecContext(codec: codec)
                    codecCtx.setParameters(stream.codecParameters)
                    print("AVCodecContext -  mediaType: \(codecCtx.mediaType), width: \(codecCtx.width), height: \(codecCtx.height), audio sample format: \(codecCtx.sampleFormat), framerate: \(codecCtx.framerate)")
                    try codecCtx.openCodec()
                    
                    let pkt = AVPacket()
                    let frame = AVFrame()
                    
                    let videoWriter: AVAssetWriter
                    do {
                        videoWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mov)
                    } catch {
                        throw Error.initExtractionError(.failedToCreateAVAssetWriter)
                    }
                    
                    let outputSettings: [String: Any] = [
                        AVFoundation.AVVideoCodecKey: AVFoundation.AVVideoCodecType.jpeg,
                        AVFoundation.AVVideoWidthKey: NSNumber.init(value: codecCtx.width),
                        AVFoundation.AVVideoHeightKey: NSNumber.init(value: codecCtx.height)
                    ]
                    
                    let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings, sourceFormatHint: nil)
                    
                    
                    let sourcePixelBufferAttributes: [String: Any] = [
                        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
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
                            let _ = try fmtCtx.readFrame(into: pkt)
                        } catch let error as SwiftFFmpeg.AVError {
                            if error == .eof {
                                break
                            } else {
                                fatalError("⚠️ Failed to read frame, error: \(error)")
                            }
                        }
                        
                        defer { pkt.unref() }
                        
                        if pkt.streamIndex != stream.index {
                            continue
                        }
                        
                        guard stream.mediaType == .video else {
                            continue
                        }
                        
                        try codecCtx.sendPacket(pkt)
                        
                        while true {
                            do {
                                try codecCtx.receiveFrame(frame)
                            } catch let err as SwiftFFmpeg.AVError where err == .tryAgain || err == .eof {
                                break
                            }
                            
                            let str = String(
                                format: "Frame %3d (type=%@, size=%5d bytes), pts=%4lld, isKeyFrame=%@",
                                codecCtx.frameNumber,
                                frame.pictureType.description,
                                frame.pktSize,
                                frame.pts,
                                (frame.isKeyFrame ? "YES" : "NO")
                            )
                            
                            print(str)
                            
                            print("✨ Trying to create image from frame")
                            

//                            var dataSingleFrame = Data()
//                            for (frameDataIndex, maybeFrameData) in frame.data.enumerated() {
//                                guard let frameData = maybeFrameData else {
//                                    break
//                                }
//                                let byteCount = Int(frame.linesize[frameDataIndex])
//                                let singleFramePartData = Data(bytesNoCopy: .init(frameData), count: byteCount, deallocator: .none)
//                                dataSingleFrame.append(contentsOf: singleFramePartData)
//                            }
//
////                            let pixels: [UInt32] = {
////                                if let palette = maybePalette {
////                                    let palette32Bit = palette.toU32Array()
////
////                                    let pixels: [UInt32] = pixelData.map {
////                                        palette32Bit[Int($0)]
////                                    }
////                                    return pixels
////                                } else {
////                                   return pixelsFrom(data: pixelData)
////                                }
////                            }()
//
//                            let imageLoader = ImageLoader()
//
////                            let pixels: [UInt32] = dataSingleFrame.chunked
//                            let pixels = imageLoader.pixelsFrom(data: dataSingleFrame, bytesPerPixel: 4)
//
//                            let pixelMatrix: [[UInt32]] = pixels.chunked(into: frame.width, assertSameLength: false)
//
//                            let cgImage = try imageLoader.makeCGImage(pixelValueMatrix: pixelMatrix)
//
////                            guard let ciImage = CIImage(data: dataSingleFrame) else {
////                                fatalError("Failed to create CI image from data")
//                            //                            }
//
//                            let ciImage = CIImage(cgImage: cgImage)
                            
                            
                            
                            let pixelBufferAttributes: [String: Any] = [
                                kCVPixelBufferCGImageCompatibilityKey as String: true,
                                kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
                            ]
                            
                            func pixelFormat() -> OSType {
                                switch frame.pixelFormat {
                                case .ARGB: return kCVPixelFormatType_32ARGB
                                case .RGBA: return kCVPixelFormatType_32RGBA
                                case .YUV420P: return kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
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
                            
                            try self.savePNG(frame, to: tmpOutputURL.absoluteString)
                            guard let ciImage = CIImage.init(contentsOf: tmpOutputURL) else {
                                fatalError("failed to load image at url")
                            }
                            
                            let ciContext = CIContext()
                            ciContext.render(ciImage, to: cvPixelBuffer)
                            
                            
                            print("✨ did render image in CIContext")
                            
                            let presentationTime = CMTimeMakeWithSeconds(
                                .init(frame.bestEffortTimestamp),
                                preferredTimescale: .init(stream.timebase.num)
                            )
                            print("✨ created presentationTime: \(presentationTime)")
                            
                            pixelBufferAdaptor.append(
                                cvPixelBuffer,
                                withPresentationTime: presentationTime
                            )
                            
                            print("✅ did append cvPixelBuffer to pixelBufferAdaptor")
                            
                            frame.unref()
                        }
                    }
                    
                    writerInput.markAsFinished()
                    videoWriter.finishWriting {
                        if let error = videoWriter.error {
                            print("🚨 failed to write video")
                            promise(.failure(VideoExtractor.Error.extractionFinishError(error)))
                        } else {
                            print("👻🔮 successfully wrote video to output url: \(outputURL)")
                            promise(.success(outputURL))
                        }
                    }
                }
                catch let error as VideoExtractor.Error {
                    promise(.failure(error))
                } catch {
                    uncaught(error: error)
                }
            }
        }.eraseToAnyPublisher()
    }
    
    private func savePNG(_ frame: AVFrame, to url: String) throws {
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
        // buffer is going to be written to rawvideo file, no alignment
//        let dstData = UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>.allocate(capacity: 4)
//        let dstLinesize = UnsafeMutablePointer<Int32>.allocate(capacity: 4)
//        defer {
//            dstData.deallocate()
//            dstLinesize.deallocate()
//        }

        let dstBuf = AVImage.init(width: dstFrame.width, height: dstFrame.height, pixelFormat: dstFrame.pixelFormat, align: 1)
     
//        assert(dstBuf.size > 0)
        
//        if dstBufSize < 0 {
//            fatalError("Could not allocate destination image")
//        }


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
        

//        dstFrame.data = [dstData[0], dstData[1], dstData[2], dstData[3]]
//        dstFrame.linesize = [Int(dstLinesize[0]), Int(dstLinesize[1]), Int(dstLinesize[2]), Int(dstLinesize[3])]

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

//            try fmtCtx.interleavedWriteFrame(pkt: dstPkt)
            try fmtCtx.interleavedWriteFrame(dstPkt)

            dstPkt.unref()
        }
        dstFrame.unref()

        try fmtCtx.writeTrailer()
    }
}
