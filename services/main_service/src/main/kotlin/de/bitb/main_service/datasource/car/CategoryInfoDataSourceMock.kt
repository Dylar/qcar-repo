package de.bitb.main_service.datasource.car

import de.bitb.main_service.models.*
import org.springframework.stereotype.Repository

@Repository(CATEGORY_REPOSITORY_MOCK)
class CategoryInfoDataSourceMock : CategoryInfoDataSource {

    private val categoryInfoDB = mutableListOf<CategoryInfo>()

    override fun getCategoryInfo(brand: String, model: String, name: String): CategoryInfo? {
        return categoryInfoDB.find { it.brand == brand && it.model == model && it.name == name }
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