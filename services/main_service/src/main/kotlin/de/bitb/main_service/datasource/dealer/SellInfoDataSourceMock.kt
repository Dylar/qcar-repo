package de.bitb.main_service.datasource.dealer

import de.bitb.main_service.models.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Repository

@Repository(SALE_REPOSITORY_MOCK)
class SaleInfoDataSourceMock : SaleInfoDataSource {

    private val log: Logger = LoggerFactory.getLogger(SaleInfoDataSourceMock::class.java)

    private val saleInfoDb = mutableMapOf<String, SaleInfo>()

    override fun getSaleInfo(key: String): SaleInfo? {
        return saleInfoDb[key]
    }

    override fun addSaleInfo(info: SaleInfo) {
        saleInfoDb[info.key] = info
    }

}