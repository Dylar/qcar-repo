package de.bitb.main_service.datasource.category_info

import de.bitb.main_service.models.*
import org.springframework.stereotype.Repository

@Repository("category_info_database_mock")
class MockCategoryInfoDataSource : CategoryInfoDataSource {

    private val categoryInfoDB = mutableListOf<CategoryInfo>()

    override fun getCategoryInfo(name: String): CategoryInfo? {
      return  categoryInfoDB.find { it.name == name }
    }

    override fun addCategoryInfo(info: CategoryInfo) {
        if (categoryInfoDB.contains(info)) {
            categoryInfoDB.replaceAll {
                if (it.name == info.name) info
                else it
            }
        } else {
            categoryInfoDB.add(info)
        }
    }

}