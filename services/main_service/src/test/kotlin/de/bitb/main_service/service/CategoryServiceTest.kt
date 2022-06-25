package de.bitb.main_service.service

import de.bitb.main_service.builder.buildCategoryInfo
import de.bitb.main_service.builder.buildEmptyCategoryInfo
import de.bitb.main_service.datasource.category_info.CategoryInfoDataSource
import de.bitb.main_service.exceptions.CategoryInfoException
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.assertj.core.api.Assertions.assertThat
import org.assertj.core.api.AssertionsForInterfaceTypes
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.lang.Exception

internal class CategoryServiceTest {

    private lateinit var dataSource: CategoryInfoDataSource
    private lateinit var service: CategoryInfoService

    @BeforeEach
    fun setUp() {
        dataSource = mockk(relaxed = true)
        every { dataSource.getCategoryInfo(any(), any(), any()) }.returns(null)
        service = CategoryInfoService(dataSource)
    }

    @Test
    fun `get category from service`() {
        //given
        val testInfo = buildCategoryInfo()
        every { dataSource.getCategoryInfo(testInfo.brand, testInfo.model, testInfo.name) }.returns(
            testInfo
        )
        //when
        val info = service.getCategoryInfo(testInfo.brand, testInfo.model, testInfo.name)
        //then
        verify(exactly = 1) {
            dataSource.getCategoryInfo(
                testInfo.brand,
                testInfo.model,
                testInfo.name
            )
        }
        assertThat(info == testInfo)
    }

    @Test
    fun `get no category from datasource - throw UnknownCategoryException`() {
        //given
        val testInfo = buildCategoryInfo()
        //when
        val exceptionNoInfo: Exception =
            assertThrows { service.getCategoryInfo(testInfo.brand, testInfo.model, testInfo.name) }
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

    @Test
    fun `try adding invalid category - throw exceptions`() {
        var emptyInfo = buildEmptyCategoryInfo()
        var exception: Exception = assertThrows { service.addCategoryInfo(emptyInfo) }
        assertThat(exception is CategoryInfoException.EmptyBrandException)

        emptyInfo = emptyInfo.copy(brand = "Toyota")
        exception = assertThrows { service.addCategoryInfo(emptyInfo) }
        assertThat(exception is CategoryInfoException.EmptyModelException)

        emptyInfo = emptyInfo.copy(model = "Corolla")
        exception = assertThrows { service.addCategoryInfo(emptyInfo) }
        assertThat(exception is CategoryInfoException.EmptyNameException)

        emptyInfo = emptyInfo.copy(name = "Sicherheit")
        exception = assertThrows { service.addCategoryInfo(emptyInfo) }
        assertThat(exception is CategoryInfoException.EmptyDescriptionException)

        emptyInfo = emptyInfo.copy(description = "Hier gehts um KEINE Sicherheit")
        exception = assertThrows { service.addCategoryInfo(emptyInfo) }
        assertThat(exception is CategoryInfoException.EmptyImagePathException)

        emptyInfo = emptyInfo.copy(imagePath = "path/to/file")
        service.addCategoryInfo(emptyInfo)
        verify(exactly = 1) { dataSource.addCategoryInfo(emptyInfo) }
    }
}