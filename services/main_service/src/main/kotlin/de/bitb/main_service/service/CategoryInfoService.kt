package de.bitb.main_service.service

import de.bitb.main_service.datasource.category_info.CategoryInfoDataSource
import de.bitb.main_service.exceptions.CategoryInfoException
import de.bitb.main_service.models.CategoryInfo
import de.bitb.main_service.models.validateCategoryInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service
class CategoryInfoService(
        @Qualifier("category_info_database_mock") @Autowired val categoryDS: CategoryInfoDataSource,
) {

    private val log: Logger = LoggerFactory.getLogger(CategoryInfoService::class.java)

    @Throws(CategoryInfoException.UnknownCategoryException::class)
    fun getCategoryInfo(name: String): CategoryInfo = categoryDS.getCategoryInfo(name)
            ?: throw CategoryInfoException.UnknownCategoryException(name)

    @Throws(CategoryInfoException::class)
    fun addCategoryInfo(info: CategoryInfo) {
        validateCategoryInfo(info)
        categoryDS.addCategoryInfo(info)
    }
}