//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-11.
//

import Foundation

extension Laka.Textures {
    
    private var dwelling: [String] {
        [
            "avgpike0.def",
            "avgcros0.def",
            "avggrff0.def",
            "avgswor0.def",
            "avgmonk0.def",
            "avgcavl0.def",
            "avgangl0.def",
            "avgcent0.def",
            "avgdwrf0.def",
            "avgelf0.def",
            "avgpega0.def",
            "avgtree0.def",
            "avgunic0.def",
            "avggdrg0.def",
            "avggrem0.def",
            "avggarg0.def",
            "avggolm0.def",
            "avgmage0.def",
            "avggeni0.def",
            "avgnaga0.def",
            "avgtitn0.def",
            "avgimp0.def",
            "avggogs0.def",
            "avghell0.def",
            "avgdemn0.def",
            "avgpit0.def",
            "avgefre0.def",
            "avgdevl0.def",
            "avgskel0.def",
            "avgzomb0.def",
            "avgwght0.def",
            "avgvamp0.def",
            "avglich0.def",
            "avgbkni0.def",
            "avgbone0.def",
            "avgtrog0.def",
            "avgharp0.def",
            "avgbhld0.def",
            "avgmdsa0.def",
            "avgmino0.def",
            "avgmant0.def",
            "avgrdrg0.def",
            "avggobl0.def",
            "avgwolf0.def",
            "avgorcg0.def",
            "avgogre0.def",
            "avgrocs0.def",
            "avgcycl0.def",
            "avgbhmt0.def",
            "avggnll0.def",
            "avglzrd0.def",
            "avgdfly0.def",
            "avgbasl0.def",
            "avggorg0.def",
            "avgwyvn0.def",
            "avghydr0.def",
            "avgelem0.def",
            "avgair0.def",
            "avgerth0.def",
            "avgfire0.def",
            "avgwatr0.def",
            "avgrust.def",
            "avgpixie.def",
            "avgelp.def",
            "avgfbrd.def",
            "avgench.def",
            "avgshrp.def",
            "avg2ela.def",
            "avg2ele.def",
            "avg2elf.def",
            "avg2elw.def",
            "avg2uni.def",
            "avgazur.def",
            "avgcdrg.def",
            "avgfdrg.def",
            "avghalf.def",
            "avgpeas.def",
            "avgboar.def",
            "avgmumy.def",
            "avgnomd.def",
            "avgrog.def",
            "avgtrll.def",
            "avrcgen0.def",
            "avrcgn00.def",
            "avrcgn01.def",
            "avrcgn02.def",
            "avrcgn03.def",
            "avrcgn04.def",
            "avrcgn05.def",
            "avrcgn06.def",
            "avrcgn07.def",
            "avrcgn08.def",
            "avrcgen1.def",
            "avrcgen2.def",
            "avrcgen3.def",
            "avrcgen4.def",
            "avrcgen5.def",
            "avrcgen6.def",
            "avrcgen7.def",
            "avgnoll.def"
          ]
    }
    
    func exportDwelling() throws {
        let dwellingFileList = dwelling.map { defFileName in
            ImageExport(defFileName: defFileName, nameFromFrameAtIndexIndex: { _, _ in defFileName })
        }
        
        try generateTexture(
            name: "dwelling",
            list: dwellingFileList,
            maxImageCountPerDefFile: 1
        )
    }
}
