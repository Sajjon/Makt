//
//  GoodToGoMapTest.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-13.
//


    /*
    func test_assert_small_map_kneeDeepInTheDead() throws {
        let map = try Map.load(.kneeDeepInTheDead)
        XCTAssertEqual(map.about.summary.fileName, "Knee Deep in the Dead.h3m")
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 6_909)
        XCTAssertEqual(map.about.summary.fileSize, 1)
    }

    func test_assert_small_map_tooManyMonsters() throws {
        let map = try Map.load(.tooManyMonsters)
        XCTAssertEqual(map.about.summary.fileName, "Too Many Monsters.h3m")
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 7_569)
        XCTAssertEqual(map.about.summary.fileSize, 1)
    }

    func test_assert_small_map_forSale() throws {
        let map = try Map.load(.forSale)
        XCTAssertEqual(map.about.summary.fileName, "For Sale.h3m")
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 8_434)
        XCTAssertEqual(map.about.summary.fileSize, 1)
    }

    /// After `goodToGo` and `elbowRoom`: smallest compressed file size
    func test_assert_a_really_small_map_judgementDay() throws {



        let inspector = Map.Loader.Parser.Inspector(
            settings: .init(),
            onParseAbout: { about in
                let summary = about.summary

                XCTAssertEqual(summary.fileName, "Judgement Day.h3m")
                XCTAssertEqual(summary.fileSizeCompressed, 5_059)
                XCTAssertEqual(summary.fileSize, 21201)
                XCTAssertEqual(summary.format, .restorationOfErathia)
            },
            onParseDisposedHeroes: { disposedHeroes in
                XCTAssertTrue(disposedHeroes.isEmpty)
            },
            onParseAllowedArtifacts: { allowedArtifacts in
                XCTAssertEqual(allowedArtifacts, Artifact.ID.available(in: .restorationOfErathia))
            },
            onParseAllowedSpells: { allowedSpells in
                XCTAssertEqual(allowedSpells, Spell.ID.allCases)
            },
            onParseAllowedHeroAbilities: { allowedSeconarySkills in
                XCTAssertEqual(allowedSeconarySkills, Hero.SecondarySkill.Kind.allCases)
            },
            onParseRumors: { rumors in
                XCTAssertTrue(rumors.isEmpty)
            },
            onParsePredefinedHeroes: { predefinedHeroes in
                XCTAssertTrue(predefinedHeroes.isEmpty)
            },
            onParseWorld: { world in
                print(world.above)
                XCTAssertNil(world.belowGround)
                XCTAssertFalse(world.above.isUnderworld)
                let tiles = world.above.tiles
                XCTAssertEqual(tiles.count, 36*36)
            },
            onParseAttributes: { attributes in
                XCTAssertEqual(attributes.attributes.count, 111)

            },
            onParseObject: { object in
            })

        do {
            let _ = try Map.load(.judgementDay, inspector: inspector)
        } catch {
            // errors are ignored for now.
        }
    }

    /// After `goodToGo`: smallest compressed file size
    func test_assert_a_really_small_map_elbowRoom() throws {


        let inspector = Map.Loader.Parser.Inspector(
            settings: .init(),
            onParseAbout: { about in
                let summary = about.summary
                XCTAssertEqual(summary.fileName, "Elbow Room.h3m")
                XCTAssertEqual(summary.fileSizeCompressed, 4_996)
                XCTAssertEqual(summary.fileSize, 24_590)
                XCTAssertEqual(summary.format, .armageddonsBlade)
            },
            onParseDisposedHeroes: { disposedHeroes in
                XCTAssertTrue(disposedHeroes.isEmpty)
            },
            onParseAllowedArtifacts: { allowedArtifacts in
                XCTAssertFalse(allowedArtifacts.isEmpty)
            },
            onParseAllowedSpells: { allowedSpells in
                XCTAssertEqual(allowedSpells, Spell.ID.allCases)
            },
            onParseAllowedHeroAbilities: { allowedSeconarySkills in
                XCTAssertEqual(allowedSeconarySkills, Hero.SecondarySkill.Kind.allCases)
            },
            onParseRumors: { rumors in
                XCTAssertTrue(rumors.isEmpty)
            },
            onParsePredefinedHeroes: { predefinedHeroes in
                XCTAssertTrue(predefinedHeroes.isEmpty)
            },
            onParseWorld: { world in
                print(world.above)
                XCTAssertNil(world.belowGround)
                XCTAssertFalse(world.above.isUnderworld)
                let tiles = world.above.tiles
                XCTAssertEqual(tiles.count, 36*36)
            },
            onParseAttributes: { attributes in
                XCTAssertEqual(attributes.attributes.count, 121)
            },
            onParseObject: { object in

            })

            let _ = try Map.load(.elbowRoom, inspector: inspector)

    }

    func test_assert_can_load_map_by_id__tutorial_map() throws {
        let map = try Map.load(.tutorial)
        XCTAssertEqual(map.about.summary.fileName, "Tutorial.tut")
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 6_152)
        XCTAssertEqual(map.about.summary.fileSize, 27_972)
    }

    func test_assert_can_load_map_by_id__titans_winter() throws {
        // Delete any earlier cached maps.
        Map.loader.cache .__deleteMap(by: .titansWinter)
        let map = try Map.load(.titansWinter)
        XCTAssertEqual(map.about.summary.fileName, "Titans Winter.h3m")
        XCTAssertEqual(map.about.summary.name, "Titan's Winter")
        XCTAssertEqual(map.about.summary.description, "A terrible earthquake has torn apart the land.  Many different factions have arisen.  Now is the time for you to reunite the Kingdom, but this time under YOUR banner! ")
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 30374)
        XCTAssertEqual(map.about.summary.fileSize, 149258)
        XCTAssertEqual(map.about.summary.hasTwoLevels, false)
        XCTAssertEqual(map.about.summary.format, .restorationOfErathia)
        XCTAssertEqual(map.about.summary.difficulty, .hard)
        XCTAssertEqual(map.about.summary.size, .large)
        XCTAssertEqual(map.about.playersInfo.players.count, 6)
        XCTAssertEqual(map.about.playersInfo.players.map { $0.player }, [.playerOne, .playerTwo, .playerThree, .playerFour, .playerFive, .playerSix])
        XCTAssertEqual(map.about.playersInfo.players[0].isPlayableBothByHumanAndAI, true)
        XCTAssertEqual(map.about.playersInfo.players[1].isPlayableBothByHumanAndAI, true)
        XCTAssertEqual(map.about.playersInfo.players[2].isPlayableBothByHumanAndAI, true)

        XCTAssertEqual(map.about.playersInfo.players[0].townTypes, [.tower])
        XCTAssertEqual(map.about.playersInfo.players[1].townTypes, [.tower])
        XCTAssertEqual(map.about.playersInfo.players[2].townTypes, [.tower])
        XCTAssertEqual(map.about.playersInfo.players[3].townTypes, [.stronghold])
        XCTAssertEqual(map.about.playersInfo.players[4].townTypes, [.dungeon])
        XCTAssertEqual(map.about.playersInfo.players[5].townTypes, [.castle])

        XCTAssertEqual(map.about.victoryLossConditions.victoryConditions, [.standard])
        XCTAssertEqual(map.about.victoryLossConditions.lossConditions, [.standard])
    }



    func test_assert_can_load_map_by_id__vikingWeShallGo() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .vikingWeShallGo)
        let map = try Map.load(.vikingWeShallGo)
        XCTAssertEqual(map.about.summary.fileName, "A Viking We Shall Go.h3m")
        XCTAssertEqual(map.about.summary.name, "Viking We Shall Go!")
        XCTAssertEqual(map.about.summary.description,
            """
            The Place: Europe
            The Time: The Dark Ages
            Vikings have begun their raids while the kings of Europe take the opportunity to grab land from their neighbors.
            """)
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 47_404 )
        XCTAssertEqual(map.about.summary.fileSize, 226_324)
        XCTAssertFalse(map.about.summary.hasTwoLevels)
        XCTAssertEqual(map.about.summary.format, .shadowOfDeath)
        XCTAssertEqual(map.about.summary.difficulty, .normal)
        XCTAssertEqual(map.about.summary.size, .extraLarge)
        XCTAssertEqual(map.about.playersInfo.players.count, 6)

        XCTAssertTrue(map.about.playersInfo.players.prefix(5).allSatisfy({ $0.isPlayableBothByHumanAndAI }))
        XCTAssertTrue(map.about.playersInfo.players[5].isPlayableOnlyByAI)

        XCTAssertEqual(
            map.about.playersInfo.players.flatMap({ $0.townTypes }),
            [.stronghold, .necropolis, .castle, .rampart, .castle, .inferno]
        )

        XCTAssertEqual(map.about.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.standard])
        XCTAssertEqual(map.about.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
    }


    func test_assert_can_load_map_by_id__mandateOfHeaven() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .theMandateOfHeaven)
        let map = try Map.load(.theMandateOfHeaven)
        XCTAssertEqual(map.about.summary.fileName, "The Mandate of Heaven.h3m")
        XCTAssertEqual(map.about.summary.name, "The Mandate of Heaven")
        XCTAssertEqual(map.about.summary.description, "Devils have invaded and it is up to you to win back the Mandate of Heaven for the faltering Ironfist Dynasty")
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 70_517 )
        XCTAssertEqual(map.about.summary.fileSize, 399_506)
        XCTAssertTrue(map.about.summary.hasTwoLevels)
        XCTAssertEqual(map.about.summary.format, .restorationOfErathia)
        XCTAssertEqual(map.about.summary.difficulty, .expert)
        XCTAssertEqual(map.about.summary.size, .extraLarge)
        XCTAssertEqual(map.about.playersInfo.players.count, 5)

        XCTAssertTrue(map.about.playersInfo.players[0].isPlayableBothByHumanAndAI)
        XCTAssertTrue(map.about.playersInfo.players.suffix(4).allSatisfy({ $0.isPlayableOnlyByAI }))

        XCTAssertEqual(map.about.playersInfo.players[0].townTypes, [.castle])
        XCTAssertEqual(map.about.playersInfo.players[1].townTypes, [.necropolis])
        XCTAssertEqual(map.about.playersInfo.players[2].townTypes, [.inferno])
        XCTAssertEqual(map.about.playersInfo.players[3].townTypes, [.dungeon])
        XCTAssertEqual(map.about.playersInfo.players[4].townTypes, [.dungeon])

        XCTAssertFalse(map.about.playersInfo.players[2].hasRandomHero)
        XCTAssertEqual(map.about.playersInfo.players[2].customMainHero?.name, "The Queen")
        XCTAssertEqual(map.about.playersInfo.players[2].customMainHero?.portraitId, .calid)

        XCTAssertEqual(map.about.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.captureSpecificTown])
        XCTAssertEqual(map.about.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
    }

    func test_assert_can_load_map_by_id__rebellion() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .rebellion)
        let map = try Map.load(.rebellion)
        XCTAssertEqual(map.about.summary.fileName, "Rebellion.h3m")
        XCTAssertEqual(map.about.summary.name, "Rebellion")
        XCTAssertEqual(map.about.summary.description, "The peasants are revolting, just when you need them to fight a war.  The only hope for peace lies in finding the Grail.")
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 18_107)
        XCTAssertEqual(map.about.summary.fileSize, 81_093)
        XCTAssertFalse(map.about.summary.hasTwoLevels)
        XCTAssertEqual(map.about.summary.format, .restorationOfErathia)
        XCTAssertEqual(map.about.summary.difficulty, .normal)
        XCTAssertEqual(map.about.summary.size, .medium)
        XCTAssertEqual(map.about.playersInfo.players.count, 3)

        XCTAssertTrue(map.about.playersInfo.players.allSatisfy({ $0.isPlayableBothByHumanAndAI }))

        XCTAssertEqual(map.about.playersInfo.players[0].townTypes, Faction.playable(in: .restorationOfErathia))
        XCTAssertEqual(map.about.playersInfo.players[1].townTypes, [.inferno])
        XCTAssertEqual(map.about.playersInfo.players[2].townTypes, [.stronghold])

        XCTAssertEqual(map.about.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.buildGrailBuilding, .standard])
        XCTAssertEqual(map.about.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
    }

    func test_assert_can_load_map_by_id__noahsArk() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .noahsArk)
        let map = try Map.load(.noahsArk)
        XCTAssertEqual(map.about.summary.fileName, "Noahs Ark.h3m")
        XCTAssertEqual(map.about.summary.name, "Noah's Ark")
        XCTAssertEqual(map.about.summary.description, "The great flood is coming, and only by controlling two of every creature dwelling can you hope to survive.")
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 38_907)
        XCTAssertEqual(map.about.summary.fileSize, 222_532)
        XCTAssertTrue(map.about.summary.hasTwoLevels)
        XCTAssertEqual(map.about.summary.format, .restorationOfErathia)
        XCTAssertEqual(map.about.summary.difficulty, .normal)
        XCTAssertEqual(map.about.summary.size, .large)
        XCTAssertEqual(map.about.playersInfo.players.count, 3)

        XCTAssertTrue(map.about.playersInfo.players.prefix(2).allSatisfy({ $0.isPlayableBothByHumanAndAI }))
        XCTAssertTrue(map.about.playersInfo.players[2].isPlayableOnlyByAI)

        XCTAssertEqual(map.about.playersInfo.players[0].townTypes, Faction.playable(in: .restorationOfErathia))
        XCTAssertEqual(map.about.playersInfo.players[1].townTypes, Faction.playable(in: .restorationOfErathia))
        XCTAssertEqual(map.about.playersInfo.players[2].townTypes, Faction.playable(in: .restorationOfErathia))

        XCTAssertEqual(map.about.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.flagAllCreatureDwellings, .standard])
        XCTAssertEqual(map.about.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
    }

    func test_assert_can_load_map_by_id__overthrowThyNeighbour() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .overthrowThyNeighbour)
        let map = try Map.load(.overthrowThyNeighbour)
        XCTAssertEqual(map.about.summary.fileName, "Overthrow Thy Neighbors.h3m")
        XCTAssertEqual(map.about.summary.name, "Overthrow Thy Neighbors")
        XCTAssertEqual(map.about.summary.description, "The good, the bad, and the over crowded.")
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 27_119)
        XCTAssertEqual(map.about.summary.fileSize, 132_820)
        XCTAssertTrue(map.about.summary.hasTwoLevels)
        XCTAssertEqual(map.about.summary.format, .restorationOfErathia)
        XCTAssertEqual(map.about.summary.difficulty, .normal)
        XCTAssertEqual(map.about.summary.size, .medium)
        XCTAssertEqual(map.about.playersInfo.players.count, 3)

        XCTAssertTrue(map.about.playersInfo.players.allSatisfy({ $0.isPlayableBothByHumanAndAI }))

        XCTAssertEqual(map.about.playersInfo.players[0].townTypes, [.inferno])
        XCTAssertEqual(map.about.playersInfo.players[1].townTypes, [.stronghold])
        XCTAssertEqual(map.about.playersInfo.players[2].townTypes, [.castle])

        XCTAssertEqual(map.about.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.flagAllMines, .standard])
        XCTAssertEqual(map.about.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
    }

    func test_assert_can_load_map_by_id__mythAndLegend() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .mythAndLegend)
        let map = try Map.load(.mythAndLegend)
        XCTAssertEqual(map.about.summary.fileName, "Myth and Legend.h3m")
        XCTAssertEqual(map.about.summary.name, "Myth and Legend")
        XCTAssertEqual(map.about.summary.description, "You are a God.  Scaring mortals, granting wishes and generally mucking about Greece has been great fun, but with all fun it eventually turns to boredom.  Fortunately Autolycus has provided you and the other gods with some amusement.  He has stolen the Titan's Cuirass and you must find it first.")
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 123_343)
        XCTAssertEqual(map.about.summary.fileSize, 520_208)
        XCTAssertTrue(map.about.summary.hasTwoLevels)
        XCTAssertEqual(map.about.summary.format, .restorationOfErathia)
        XCTAssertEqual(map.about.summary.difficulty, .normal)
        XCTAssertEqual(map.about.summary.size, .extraLarge)
        XCTAssertEqual(map.about.playersInfo.players.count, 8)

        XCTAssertTrue(map.about.playersInfo.players.prefix(3).allSatisfy({ $0.isPlayableOnlyByAI }))
        XCTAssertTrue(map.about.playersInfo.players.suffix(5).allSatisfy({ $0.isPlayableBothByHumanAndAI }))

        XCTAssertEqual(map.about.playersInfo.players[0].townTypes, [.castle])
        XCTAssertEqual(map.about.playersInfo.players[1].townTypes, [.dungeon])
        XCTAssertEqual(map.about.playersInfo.players[2].townTypes, [.inferno])
        XCTAssertEqual(map.about.playersInfo.players[3].townTypes, [.castle])
        XCTAssertEqual(map.about.playersInfo.players[4].townTypes, [.rampart])
        XCTAssertEqual(map.about.playersInfo.players[5].townTypes, [.dungeon])
        XCTAssertEqual(map.about.playersInfo.players[6].townTypes, [.tower])
        XCTAssertEqual(map.about.playersInfo.players[7].townTypes, [.rampart])

        XCTAssertEqual(map.about.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.acquireSpecificArtifact, .standard])
        XCTAssertEqual(map.about.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
    }

    func test_assert_can_load_map_by_id__thousandIslands_allies() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .thousandIslandsAllies)
        let map = try Map.load(.thousandIslandsAllies)
        XCTAssertEqual(map.about.summary.fileName, "Thousand Islands (allies).h3m")
        XCTAssertEqual(map.about.summary.name, "Thousand Islands (Allies)")
        XCTAssertEqual(map.about.summary.description, "An evil wizard has cast a spell that has caused volcanoes to erupt on the islands of Norkko. The people are in a state of panic and no one knows who the evil wizard is. These vicious volcanoes destroy entire towns. Someone must find him and destroy him.")
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 50_765)
        XCTAssertEqual(map.about.summary.fileSize, 240_048)
        XCTAssertFalse(map.about.summary.hasTwoLevels)
        XCTAssertEqual(map.about.summary.format, .armageddonsBlade)
        XCTAssertEqual(map.about.summary.difficulty, .normal)
        XCTAssertEqual(map.about.summary.size, .extraLarge)
        XCTAssertEqual(map.about.playersInfo.players.count, 7)

        XCTAssertTrue(map.about.playersInfo.players.prefix(5).allSatisfy({ $0.isPlayableBothByHumanAndAI }))
        XCTAssertTrue(map.about.playersInfo.players[5].isPlayableOnlyByAI)
        XCTAssertTrue(map.about.playersInfo.players[6].isPlayableBothByHumanAndAI)

        XCTAssertTrue(map.about.playersInfo.players.allSatisfy({ $0.townTypes == Faction.playable(in: .restorationOfErathia) }))

        XCTAssertEqual(map.about.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.defeatSpecificHero])
        XCTAssertEqual(map.about.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])

        XCTAssertEqual(map.about.teamInfo, [[.playerOne, .playerTwo], [.playerThree, .playerFour], [.playerFive, .playerSeven], [.playerSix]])
    }

    func test_assert_can_load_map_by_id__reclamation_allies() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .reclamationAllies)
        let map = try Map.load(.reclamationAllies)
        XCTAssertEqual(map.about.summary.fileName, "Reclamation Allied.h3m")
        XCTAssertEqual(map.about.summary.name, "Reclamation (Allies)")
        XCTAssertEqual(map.about.summary.description, "Eons ago, three nations were defeated by invaders and driven from their ancestral lands.  The victorious nation has since split into several smaller kingdoms. Now, the ancient peoples of the land are returning to seize back their homelands.  However, you refuse to let them take back what you own.")
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 53_450)
        XCTAssertEqual(map.about.summary.fileSize, 247_360)
        XCTAssertFalse(map.about.summary.hasTwoLevels)
        XCTAssertEqual(map.about.summary.format, .shadowOfDeath)
        XCTAssertEqual(map.about.summary.difficulty, .normal)
        XCTAssertEqual(map.about.summary.size, .extraLarge)
        XCTAssertEqual(map.about.playersInfo.players.count, 7)

        XCTAssertTrue(map.about.playersInfo.players.allSatisfy({ $0.isPlayableBothByHumanAndAI }))

        XCTAssertTrue(map.about.playersInfo.players.allSatisfy({ $0.townTypes == Faction.playable(in: .shadowOfDeath) }))

        XCTAssertEqual(map.about.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.standard])
        XCTAssertEqual(map.about.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])

        XCTAssertEqual(map.about.teamInfo.teams?.count, 3)
        XCTAssertEqual(map.about.teamInfo, [[.playerOne, .playerThree], [.playerTwo, .playerSeven], [.playerFour, .playerFive, .playerSix]])
    }

    func test_assert_can_load_map_by_id__peacefulEnding_allies() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .peacefulEndingAllies)
        let map = try Map.load(.peacefulEndingAllies)
        XCTAssertEqual(map.about.summary.fileName, "Peaceful Ending - Allied.h3m")
        XCTAssertEqual(map.about.summary.name, "Peaceful Ending (Allies)")
        XCTAssertEqual(map.about.summary.description, "Trade has been the key to peace for as long as everyone can remember.  Everything was going well until one nation stopped trading with the others, their reasons unknown.  War broke out, for nations desperately needed resources, and it has raged ever since.  A peace must be reached. ")
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 44_116)
        XCTAssertEqual(map.about.summary.fileSize, 240_257)
        XCTAssertTrue(map.about.summary.hasTwoLevels)
        XCTAssertEqual(map.about.summary.format, .shadowOfDeath)
        XCTAssertEqual(map.about.summary.difficulty, .hard)
        XCTAssertEqual(map.about.summary.size, .large)
        XCTAssertEqual(map.about.playersInfo.players.count, 6)

        XCTAssertTrue(map.about.playersInfo.players.allSatisfy({ $0.isPlayableBothByHumanAndAI }))
        XCTAssertTrue(map.about.playersInfo.players.allSatisfy({ $0.isRandomFaction }))

        XCTAssertTrue(map.about.playersInfo.players.allSatisfy({ $0.townTypes == Faction.playable(in: .shadowOfDeath) }))

        XCTAssertEqual(map.about.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.standard])
        XCTAssertEqual(map.about.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])

        XCTAssertEqual(map.about.teamInfo.teams?.count, 3)
        XCTAssertEqual(map.about.teamInfo, [[.playerOne, .playerSix], [.playerTwo, .playerFive], [.playerThree, .playerFour]])
    }

    
    */
