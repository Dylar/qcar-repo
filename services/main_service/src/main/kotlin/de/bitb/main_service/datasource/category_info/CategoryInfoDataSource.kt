package de.bitb.main_service.datasource.category_info

import de.bitb.main_service.models.CategoryInfo
import org.springframework.stereotype.Repository

interface CategoryInfoDataSource {
    fun getCategoryInfo(name:String) : CategoryInfo?

    fun addCategoryInfo(info: CategoryInfo)
}

@Repository("category_info_database")
class DBCategoryInfoDataSource : CategoryInfoDataSource {
    override fun getCategoryInfo(name: String): CategoryInfo? {
        TODO("Not yet implemented")
    }

    override fun addCategoryInfo(info: CategoryInfo) {
        TODO("Not yet implemented")
    }
}