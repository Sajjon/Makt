//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-11.
//

import Foundation


// MARK: - IMPASSABLE Terrain
// MARK: -
extension Laka.Textures {
    
    // MARK: Impassable Files
    private static let impassableTerrain: [String] = [
        "avlautr0.def",
        "avlautr1.def",
        "avlautr2.def",
        "avlautr3.def",
        "avlautr4.def",
        "avlautr5.def",
        "avlautr6.def",
        "avlautr7.def",
        "avlct1d0.def",
        "avlct2d0.def",
        "avlct3d0.def",
        "avlct4d0.def",
        "avlct5d0.def",
        "avlctrd0.def",
        "avldlog.def",
        "avlfl1d0.def",
        "avlfl2d0.def",
        "avlfl3d0.def",
        "avlfl4d0.def",
        "avlfl5d0.def",
        "avlfl6d0.def",
        "avlfl7d0.def",
        "avlfl8d0.def",
        "avlfl9d0.def",
        "avllk1d0.def",
        "avllk2d0.def",
        "avllk3d0.def",
        "avlmd1d0.def",
        "avlmd2d0.def",
        "avlmtdr1.def",
        "avlmtdr2.def",
        "avlmtdr3.def",
        "avlmtdr4.def",
        "avlmtdr5.def",
        "avlmtdr6.def",
        "avlmtdr7.def",
        "avlmtdr8.def",
        "avloc1d0.def",
        "avloc2d0.def",
        "avloc3d0.def",
        "avlpntr0.def",
        "avlpntr1.def",
        "avlpntr2.def",
        "avlpntr3.def",
        "avlpntr4.def",
        "avlpntr5.def",
        "avlpntr6.def",
        "avlpntr7.def",
        "avlrd01.def",
        "avlrd02.def",
        "avlrd04.def",
        "avlrk3d0.def",
        "avlrk5d0.def",
        "avlsh1d0.def",
        "avlsh2d0.def",
        "avlsh3d0.def",
        "avlsh4d0.def",
        "avlsh5d0.def",
        "avlsh6d0.def",
        "avlsh7d0.def",
        "avlsh8d0.def",
        "avlstm1.def",
        "avlstm2.def",
        "avlstm3.def",
        "avltr1d0.def",
        "avltr2d0.def",
        "avltr3d0.def",
        "avlxdt00.def",
        "avlxdt01.def",
        "avlxdt02.def",
        "avlxdt03.def",
        "avlxdt04.def",
        "avlxdt05.def",
        "avlxdt06.def",
        "avlxdt07.def",
        "avlxdt08.def",
        "avlxdt09.def",
        "avlxdt10.def",
        "avlxdt11.def",
        "clrdelt1.def",
        "clrdelt2.def",
        "clrdelt3.def",
        "clrdelt4.def",
        "muddelt1.def",
        "muddelt2.def",
        "muddelt3.def",
        "muddelt4.def",
        "avlref10.def",
        "avlref20.def",
        "avlref30.def",
        "avlref40.def",
        "avlref50.def",
        "avlref60.def",
        "avlrk1w0.def",
        "avlrk2w0.def",
        "avlrk3w0.def",
        "avlrk4w0.def",
        "avlct1g0.def",
        "avlct2g0.def",
        "avlct3g0.def",
        "avlct4g0.def",
        "avlct5g0.def",
        "avlct6g0.def",
        "avlctrg0.def",
        "avlf01g0.def",
        "avlf02g0.def",
        "avlf03g0.def",
        "avlf04g0.def",
        "avlf05g0.def",
        "avlf06g0.def",
        "avlf07g0.def",
        "avlf08g0.def",
        "avlf09g0.def",
        "avlf10g0.def",
        "avlf11g0.def",
        "avlf12g0.def",
        "avllk1g0.def",
        "avllk2g0.def",
        "avllk3g0.def",
        "avlmd1g0.def",
        "avlmd2g0.def",
        "avlmtgn0.def",
        "avlmtgn1.def",
        "avlmtgn2.def",
        "avlmtgn3.def",
        "avlmtgn4.def",
        "avlmtgn5.def",
        "avlmtgr1.def",
        "avlmtgr2.def",
        "avlmtgr3.def",
        "avlmtgr4.def",
        "avlmtgr5.def",
        "avlmtgr6.def",
        "avloc1g0.def",
        "avloc2g0.def",
        "avloc3g0.def",
        "avlrg01.def",
        "avlrg02.def",
        "avlrg03.def",
        "avlrg04.def",
        "avlrg05.def",
        "avlrg06.def",
        "avlrg07.def",
        "avlrg08.def",
        "avlrg09.def",
        "avlrg10.def",
        "avlrg11.def",
        "avlsh1g0.def",
        "avlsh2g0.def",
        "avlsh3g0.def",
        "avlsh4g0.def",
        "avlsh5g0.def",
        "avlsh6g0.def",
        "avlsptr0.def",
        "avlsptr1.def",
        "avlsptr2.def",
        "avlsptr3.def",
        "avlsptr4.def",
        "avlsptr5.def",
        "avlsptr6.def",
        "avlsptr7.def",
        "avlsptr8.def",
        "avlswmp0.def",
        "avlswmp1.def",
        "avlswmp2.def",
        "avlswmp3.def",
        "avlswmp4.def",
        "avlswmp5.def",
        "avlswmp6.def",
        "avlswmp7.def",
        "avlxgr01.def",
        "avlxgr02.def",
        "avlxgr03.def",
        "avlxgr04.def",
        "avlxgr05.def",
        "avlxgr06.def",
        "avlxgr07.def",
        "avlxgr08.def",
        "avlxgr09.def",
        "avlxgr10.def",
        "avlxgr11.def",
        "avlxgr12.def",
        "avlwlw10.def",
        "avlwlw20.def",
        "avlwlw30.def",
        "avlc10l0.def",
        "avlc11l0.def",
        "avlc12l0.def",
        "avlc13l0.def",
        "avlc14l0.def",
        "avlct1l0.def",
        "avlct2l0.def",
        "avlct3l0.def",
        "avlct4l0.def",
        "avlct5l0.def",
        "avlct6l0.def",
        "avlct7l0.def",
        "avlct8l0.def",
        "avlct9l0.def",
        "avlctrl0.def",
        "avldead0.def",
        "avldead1.def",
        "avldead2.def",
        "avldead3.def",
        "avldead4.def",
        "avldead5.def",
        "avldead6.def",
        "avldead7.def",
        "avllav10.def",
        "avllav20.def",
        "avllav30.def",
        "avllav40.def",
        "avllav50.def",
        "avllav60.def",
        "avllav70.def",
        "avllav80.def",
        "avllav90.def",
        "avllv100.def",
        "avllv110.def",
        "avllv120.def",
        "avllv130.def",
        "avllv140.def",
        "avllv150.def",
        "avllv160.def",
        "avllv170.def",
        "avllv180.def",
        "avllv190.def",
        "avllv200.def",
        "avllv210.def",
        "avllv220.def",
        "avllv230.def",
        "avllv240.def",
        "avllv250.def",
        "avllv260.def",
        "avlmtvo1.def",
        "avlmtvo2.def",
        "avlmtvo3.def",
        "avlmtvo4.def",
        "avlmtvo5.def",
        "avlmtvo6.def",
        "avlvol10.def",
        "avlvol20.def",
        "avlvol30.def",
        "avlvol40.def",
        "avlvol50.def",
        "lavdelt1.def",
        "lavdelt2.def",
        "lavdelt3.def",
        "lavdelt4.def",
        "avlbuzr0.def",
        "avlca1r0.def",
        "avlca2r0.def",
        "avlct1r0.def",
        "avlct2r0.def",
        "avlct3r0.def",
        "avlct4r0.def",
        "avlct5r0.def",
        "avlct6r0.def",
        "avlct7r0.def",
        "avlct8r0.def",
        "avlct9r0.def",
        "avlctrr0.def",
        "avlglly0.def",
        "avllk1r.def",
        "avlmd1r0.def",
        "avlmd2r0.def",
        "avlmd3r0.def",
        "avlmtrf1.def",
        "avlmtrf2.def",
        "avlmtrf3.def",
        "avlmtrf4.def",
        "avlmtrf5.def",
        "avlmtrf6.def",
        "avloc1r0.def",
        "avloc2r0.def",
        "avloc3r0.def",
        "avloc4r0.def",
        "avlr02r0.def",
        "avlr03r0.def",
        "avlr04r0.def",
        "avlr06r0.def",
        "avlr07r0.def",
        "avlr08r0.def",
        "avlr09r0.def",
        "avlr10r0.def",
        "avlr11r0.def",
        "avlr12r0.def",
        "avlr13r0.def",
        "avlr14r0.def",
        "avlr15r0.def",
        "avlroug0.def",
        "avlroug1.def",
        "avlroug2.def",
        "avlrr01.def",
        "avlrr05.def",
        "avlsh1r0.def",
        "avlsh2r0.def",
        "avlsh3r0.def",
        "avlsh4r0.def",
        "avlsh5r0.def",
        "avlsh6r0.def",
        "avlsh7r0.def",
        "avlsh8r0.def",
        "avlsh9r0.def",
        "avlskul0.def",
        "avlxro01.def",
        "avlxro02.def",
        "avlxro03.def",
        "avlxro04.def",
        "avlxro05.def",
        "avlxro06.def",
        "avlxro07.def",
        "avlxro08.def",
        "avlxro09.def",
        "avlxro10.def",
        "avlxro11.def",
        "avlxro12.def",
        "avltro00.def",
        "avltro01.def",
        "avltro02.def",
        "avltro03.def",
        "avltro04.def",
        "avltro05.def",
        "avltro06.def",
        "avltro07.def",
        "avltro08.def",
        "avltro09.def",
        "avltro10.def",
        "avltro11.def",
        "avltro12.def",
        "avltrro0.def",
        "avltrro1.def",
        "avltrro2.def",
        "avltrro3.def",
        "avltrro4.def",
        "avltrro5.def",
        "avltrro6.def",
        "avltrro7.def",
        "avlyuc10.def",
        "avlyuc20.def",
        "avlyuc30.def",
        "avlca010.def",
        "avlca020.def",
        "avlca030.def",
        "avlca040.def",
        "avlca050.def",
        "avlca060.def",
        "avlca070.def",
        "avlca080.def",
        "avlca090.def",
        "avlca100.def",
        "avlca110.def",
        "avlca120.def",
        "avlca130.def",
        "avlctds0.def",
        "avldun10.def",
        "avldun20.def",
        "avldun30.def",
        "avlmtds1.def",
        "avlmtds2.def",
        "avlmtds3.def",
        "avlmtds4.def",
        "avlmtds5.def",
        "avlmtds6.def",
        "avlplm10.def",
        "avlplm20.def",
        "avlplm30.def",
        "avlplm40.def",
        "avlplm50.def",
        "avlspit0.def",
        "avlxds01.def",
        "avlxds02.def",
        "avlxds03.def",
        "avlxds04.def",
        "avlxds05.def",
        "avlxds06.def",
        "avlxds07.def",
        "avlxds08.def",
        "avlxds09.def",
        "avlxds10.def",
        "avlxds11.def",
        "avlxds12.def",
        "avlctrs0.def",
        "avldt1s0.def",
        "avldt2s0.def",
        "avldt3s0.def",
        "avllk1s0.def",
        "avllk2s0.def",
        "avllk3s0.def",
        "avlman10.def",
        "avlman20.def",
        "avlmoss0.def",
        "avlman40.def",
        "avlman50.def",
        "avlman30.def",
        "avlmtsw1.def",
        "avlmtsw2.def",
        "avlmtsw3.def",
        "avlmtsw4.def",
        "avlmtsw5.def",
        "avlmtsw6.def",
        "avlrk1s0.def",
        "avlrk2s0.def",
        "avlrk3s0.def",
        "avlrk4s0.def",
        "avls01s0.def",
        "avls02s0.def",
        "avls03s0.def",
        "avls04s0.def",
        "avls05s0.def",
        "avls06s0.def",
        "avls07s0.def",
        "avls08s0.def",
        "avls09s0.def",
        "avls10s0.def",
        "avls11s0.def",
        "avlswp10.def",
        "avlswp20.def",
        "avlswp30.def",
        "avlswp40.def",
        "avlswp50.def",
        "avlswp60.def",
        "avlswp70.def",
        "avlswtr0.def",
        "avlswtr1.def",
        "avlswtr2.def",
        "avlswtr3.def",
        "avlswtr4.def",
        "avlswtr5.def",
        "avlswtr6.def",
        "avlswtr7.def",
        "avlswtr8.def",
        "avlswtr9.def",
        "avlswt00.def",
        "avlswt01.def",
        "avlswt02.def",
        "avlswt03.def",
        "avlswt04.def",
        "avlswt05.def",
        "avlswt06.def",
        "avlswt07.def",
        "avlswt08.def",
        "avlswt09.def",
        "avlswt10.def",
        "avlswt11.def",
        "avlswt12.def",
        "avlswt13.def",
        "avlswt14.def",
        "avlswt15.def",
        "avlswt16.def",
        "avlswt17.def",
        "avlswt18.def",
        "avlswt19.def",
        "avlxsw01.def",
        "avlxsw02.def",
        "avlxsw03.def",
        "avlxsw04.def",
        "avlxsw05.def",
        "avlxsw06.def",
        "avlxsw07.def",
        "avlxsw08.def",
        "avlxsw09.def",
        "avlxsw10.def",
        "avlxsw11.def",
        "avlctsn0.def",
        "avld1sn0.def",
        "avld2sn0.def",
        "avld3sn0.def",
        "avld4sn0.def",
        "avld5sn0.def",
        "avld6sn0.def",
        "avld7sn0.def",
        "avld8sn0.def",
        "avld9sn0.def",
        "avlddsn0.def",
        "avlddsn1.def",
        "avlddsn2.def",
        "avlddsn3.def",
        "avlddsn4.def",
        "avlddsn5.def",
        "avlddsn6.def",
        "avlddsn7.def",
        "avlflk10.def",
        "avlflk20.def",
        "avlflk30.def",
        "avlmtsn1.def",
        "avlmtsn2.def",
        "avlmtsn3.def",
        "avlmtsn4.def",
        "avlmtsn5.def",
        "avlmtsn6.def",
        "avlo1sn0.def",
        "avlo2sn0.def",
        "avlo3sn0.def",
        "avlp1sn0.def",
        "avlp2sn0.def",
        "avlr1sn0.def",
        "avlr2sn0.def",
        "avlr3sn0.def",
        "avlr4sn0.def",
        "avlr5sn0.def",
        "avlr6sn0.def",
        "avlr7sn0.def",
        "avlr8sn0.def",
        "avls1sn0.def",
        "avls2sn0.def",
        "avls3sn0.def",
        "avlsntr0.def",
        "avlsntr1.def",
        "avlsntr2.def",
        "avlsntr3.def",
        "avlsntr4.def",
        "avlsntr5.def",
        "avlsntr6.def",
        "avlsntr7.def",
        "icedelt1.def",
        "icedelt2.def",
        "icedelt3.def",
        "icedelt4.def",
        "avlct1u0.def",
        "avlct2u0.def",
        "avlct3u0.def",
        "avlct4u0.def",
        "avlct5u0.def",
        "avlms010.def",
        "avlms020.def",
        "avlms030.def",
        "avlms040.def",
        "avlms050.def",
        "avlms060.def",
        "avlms070.def",
        "avlms080.def",
        "avlms090.def",
        "avlms100.def",
        "avlms110.def",
        "avlms120.def",
        "avllk1u0.def",
        "avllk2u0.def",
        "avllk3u0.def",
        "avlllk10.def",
        "avlllk20.def",
        "avllv1u0.def",
        "avllv2u0.def",
        "avllv3u0.def",
        "avlmtsb0.def",
        "avlmtsb1.def",
        "avlmtsb2.def",
        "avlmtsb3.def",
        "avlmtsb4.def",
        "avlmtsb5.def",
        "avloc1u0.def",
        "avloc2u0.def",
        "avloc3u0.def",
        "avloc4u0.def",
        "avlr01u0.def",
        "avlr02u0.def",
        "avlr03u0.def",
        "avlr04u0.def",
        "avlr05u0.def",
        "avlr06u0.def",
        "avlr07u0.def",
        "avlr08u0.def",
        "avlr09u0.def",
        "avlr10u0.def",
        "avlr11u0.def",
        "avlr12u0.def",
        "avlr13u0.def",
        "avlr14u0.def",
        "avlr15u0.def",
        "avlr16u0.def",
        "avlstg10.def",
        "avlstg20.def",
        "avlstg30.def",
        "avlstg40.def",
        "avlstg50.def",
        "avlstg60.def",
        "avlxsu01.def",
        "avlxsu02.def",
        "avlxsu03.def",
        "avlxsu04.def",
        "avlxsu05.def",
        "avlxsu06.def",
        "avlxsu07.def",
        "avlxsu08.def",
        "avlxsu09.def",
        "avlxsu10.def",
        "avlxsu11.def",
        "avlxsu12.def"
    ]
    
    static let impassableTerrainTask = GenerateAtlasTask(
        name: "Impassable Terrain",
        atlasName: "impassable_terrain",
        defList: impassableTerrain
    )
}
