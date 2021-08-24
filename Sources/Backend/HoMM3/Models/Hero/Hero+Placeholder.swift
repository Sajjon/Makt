//
//  Hero+Placeholder.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-24.
//

import Foundation

public extension Hero {
    struct Placeholder: Hashable {
        public let owner: PlayerColor
        public let `class`: Hero.Class
        
        /// VCMI `power` to multiply `class` with? What?
        public let classExtra: UInt8
    }
}

public extension Hero.Placeholder {
    
    func replaced() -> Hero {
        fatalError()
        /*
         void CGameState::replaceHeroesPlaceholders(const std::vector<CGameState::CampaignHeroReplacement> & campaignHeroReplacements)
         {
             for(auto campaignHeroReplacement : campaignHeroReplacements)
             {
                 auto heroPlaceholder = dynamic_cast<CGHeroPlaceholder*>(getObjInstance(campaignHeroReplacement.heroPlaceholderId));

                 CGHeroInstance *heroToPlace = campaignHeroReplacement.hero;
                 heroToPlace->id = campaignHeroReplacement.heroPlaceholderId;
                 heroToPlace->tempOwner = heroPlaceholder->tempOwner;
                 heroToPlace->pos = heroPlaceholder->pos;
                 heroToPlace->type = VLC->heroh->objects[heroToPlace->subID];

                 for(auto &&i : heroToPlace->stacks)
                     i.second->type = VLC->creh->objects[i.second->getCreatureID()];

                 auto fixArtifact = [&](CArtifactInstance * art)
                 {
                     art->artType = VLC->arth->objects[art->artType->id];
                     gs->map->artInstances.push_back(art);
                     art->id = ArtifactInstanceID((si32)gs->map->artInstances.size() - 1);
                 };

                 for(auto &&i : heroToPlace->artifactsWorn)
                     fixArtifact(i.second.artifact);
                 for(auto &&i : heroToPlace->artifactsInBackpack)
                     fixArtifact(i.artifact);

                 map->heroesOnMap.push_back(heroToPlace);
                 map->objects[heroToPlace->id.getNum()] = heroToPlace;
                 map->addBlockVisTiles(heroToPlace);

                 scenarioOps->campState->getCurrentScenario().placedCrossoverHeroes.push_back(CCampaignState::crossoverSerialize(heroToPlace));
             }
         }
         */
    }
    
}
