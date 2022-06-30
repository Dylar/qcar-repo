package de.bitb.main_service.datasource.intro_info

import de.bitb.main_service.models.*
import org.springframework.stereotype.Repository

@Repository(INTRO_REPOSITORY_MOCK)
class MockIntroInfoDataSource : IntroInfoDataSource {

    private val introInfoDB = mutableListOf<IntroInfo>()

    override fun getIntroInfo(
        dealer: String,
        seller: String,
        brand: String,
        model: String,
    ): IntroInfo? {
        return introInfoDB.find { it.brand == brand && it.model == model && it.seller == seller && it.dealer == dealer }
    }

    override fun addIntroInfo(info: IntroInfo) {
        if (introInfoDB.contains(info)) {
            introInfoDB.replaceAll {
                if (it == info) info
                else it
            }
        } else {
            introInfoDB.add(info)
        }
    }

}