package de.bitb.main_service.service

import de.bitb.main_service.datasource.intro_info.INTRO_REPOSITORY_IN_USE
import de.bitb.main_service.datasource.intro_info.IntroInfoDataSource
import de.bitb.main_service.exceptions.IntroInfoException
import de.bitb.main_service.models.IntroInfo
import de.bitb.main_service.models.validateIntroInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service
class IntroInfoService(
    @Qualifier(INTRO_REPOSITORY_IN_USE) @Autowired val introDS: IntroInfoDataSource,
) {

    private val log: Logger = LoggerFactory.getLogger(IntroInfoService::class.java)

    @Throws(IntroInfoException.UnknownIntroException::class)
    fun getIntroInfo(dealer: String, seller: String, brand: String, model: String): IntroInfo =
        introDS.getIntroInfo(dealer, seller, brand, model)
            ?: throw IntroInfoException.UnknownIntroException(dealer, seller, brand, model)

    @Throws(IntroInfoException::class)
    fun addIntroInfo(info: IntroInfo) {
        validateIntroInfo(info)
        introDS.addIntroInfo(info)
    }
}