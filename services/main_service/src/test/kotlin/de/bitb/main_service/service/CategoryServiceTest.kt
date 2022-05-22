package de.bitb.main_service.service

import de.bitb.main_service.builder.buildCarInfo
import de.bitb.main_service.builder.buildCategoryInfo
import de.bitb.main_service.datasource.category_info.CategoryInfoDataSource
import de.bitb.main_service.exceptions.CarInfoException
import de.bitb.main_service.exceptions.CategoryInfoException
import de.bitb.main_service.models.CategoryInfo
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.assertj.core.api.AssertionsForInterfaceTypes
import org.hamcrest.MatcherAssert.assertThat
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.lang.Exception

internal class CategoryServiceTest {

    private lateinit var dataSource: CategoryInfoDataSource
    private lateinit var service: CategoryInfoService

    @BeforeEach
    fun setUp(){
        dataSource = mockk(relaxed = true)
        every { dataSource.getCategoryInfo(any()) }.returns(null)
        service = CategoryInfoService(dataSource)
    }

    @Test
    fun `get category from service`() {
        //given
        val testInfo = buildCategoryInfo()
        val name = testInfo.name
        every { dataSource.getCategoryInfo(name) }.returns(testInfo)
        //when
        val info = service.getCategoryInfo(name)
        //then
        verify(exactly = 1) { dataSource.getCategoryInfo(name) }
        assertThat("Category info not equal", info == testInfo)
    }

    @Test
    fun `get no category from datasource - throw UnknownCategoryException`() {
        //given
        val testInfo = buildCategoryInfo()
        val name = testInfo.name
        //when
        val exceptionNoInfo: Exception = assertThrows { service.getCategoryInfo(name) }
        //then
        AssertionsForInterfaceTypes.assertThat(exceptionNoInfo is CategoryInfoException.UnknownCategoryException)
    }

    @Test
    fun `add category to service`() {
        //given
        val testInfo = buildCategoryInfo()
        //when
        service.addCategoryInfo(testInfo)
        //then
        verify(exactly = 1) { dataSource.addCategoryInfo(testInfo) }
    }
}