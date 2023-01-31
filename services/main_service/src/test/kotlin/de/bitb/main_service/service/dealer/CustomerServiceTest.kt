package de.bitb.main_service.service.dealer

import de.bitb.main_service.builder.buildEmptyCustomerInfo
import de.bitb.main_service.builder.buildCustomerInfo
import de.bitb.main_service.datasource.dealer.CustomerInfoDataSource
import de.bitb.main_service.exceptions.CustomerInfoException
import de.bitb.main_service.service.DealerInfoService
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.assertj.core.api.Assertions.assertThat
import org.assertj.core.api.AssertionsForInterfaceTypes
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.lang.Exception

internal class CustomerServiceTest {

    private lateinit var dataSource: CustomerInfoDataSource
    private lateinit var service: DealerInfoService

    @BeforeEach
    fun setUp() {
        dataSource = mockk(relaxed = true)
        every { dataSource.getCustomers(any()) }.returns(null)
        service = DealerInfoService(
            mockk(relaxed = true),
            mockk(relaxed = true),
            mockk(relaxed = true),
            mockk(relaxed = true),
            dataSource,
            mockk(relaxed = true),
        )
    }

    @Test
    fun `get customer from service`() {
        //given
        val testInfo = buildCustomerInfo()
        every { dataSource.getCustomers(testInfo.dealer) }.returns(listOf(testInfo))
        //when
        val info = service.getCustomerInfos(testInfo.dealer)
        //then
        verify(exactly = 1) { dataSource.getCustomers(testInfo.dealer) }
        assertThat(info.first() == testInfo)
    }

    @Test
    fun `get no customer from datasource - throw UnknownCustomerException`() {
        //given
        val testInfo = buildCustomerInfo()
        //when
        val exceptionNoInfo: Exception =
            assertThrows { service.getCustomerInfos(testInfo.dealer) }
        //then
        AssertionsForInterfaceTypes.assertThat(exceptionNoInfo is CustomerInfoException.UnknownDealerException)
    }

    @Test
    fun `try adding invalid customer - throw exceptions`() {
        var emptyCustomer = buildEmptyCustomerInfo()
        var exception: Exception = assertThrows { service.addCustomerInfo(emptyCustomer) }
        assertThat(exception is CustomerInfoException.EmptyDealerException)

        emptyCustomer = emptyCustomer.copy(dealer = "MuhDealer")
        exception = assertThrows { service.addCustomerInfo(emptyCustomer) }
        assertThat(exception is CustomerInfoException.EmptyNameException)

        emptyCustomer = emptyCustomer.copy(name = "Peter")
        exception = assertThrows { service.addCustomerInfo(emptyCustomer) }
        assertThat(exception is CustomerInfoException.EmptyLastNameException)

        emptyCustomer = emptyCustomer.copy(lastName = "Lustig")
        exception = assertThrows { service.addCustomerInfo(emptyCustomer) }
        assertThat(exception is CustomerInfoException.EmptyGenderException)

        emptyCustomer = emptyCustomer.copy(gender = "MALE")
        exception = assertThrows { service.addCustomerInfo(emptyCustomer) }
        assertThat(exception is CustomerInfoException.EmptyBirthdayException)

        emptyCustomer = emptyCustomer.copy(birthday = "WRONG DATE")
        exception = assertThrows { service.addCustomerInfo(emptyCustomer) }
        assertThat(exception is CustomerInfoException.WrongBirthdayFormatException)

        emptyCustomer = emptyCustomer.copy(birthday = "2022-08-04T21:55:54.940")
        exception = assertThrows { service.addCustomerInfo(emptyCustomer) }
        assertThat(exception is CustomerInfoException.EmptyPhoneException)

        emptyCustomer = emptyCustomer.copy(phone = "0190666666")
        exception = assertThrows { service.addCustomerInfo(emptyCustomer) }
        assertThat(exception is CustomerInfoException.EmptyEmailException)

        emptyCustomer = emptyCustomer.copy(email = "peter.lustig@gmx.de")
        service.addCustomerInfo(emptyCustomer)
        verify(exactly = 1) { dataSource.addCustomer(any()) }
    }

}