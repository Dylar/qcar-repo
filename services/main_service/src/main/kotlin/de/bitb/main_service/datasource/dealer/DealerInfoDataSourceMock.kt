package de.bitb.main_service.datasource.dealer

import de.bitb.main_service.models.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Repository

@Repository(DEALER_REPOSITORY_MOCK)
class DealerInfoDataSourceMock : DealerInfoDataSource {

    private val log: Logger = LoggerFactory.getLogger(DealerInfoDataSourceMock::class.java)

    private val dealerInfoDb = mutableMapOf<String, DealerInfo>()

    override fun getDealerInfo(name:String): DealerInfo? {
        return dealerInfoDb[name]
    }

    override fun addDealerInfo(info: DealerInfo) {
        dealerInfoDb[info.name] = info
    }

}