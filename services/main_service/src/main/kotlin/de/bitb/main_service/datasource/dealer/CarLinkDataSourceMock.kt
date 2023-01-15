package de.bitb.main_service.datasource.dealer

import de.bitb.main_service.models.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Repository

@Repository(CAR_LINK_REPOSITORY_MOCK)
class CarLinkDataSourceMock : CarLinkDataSource {
    private val log: Logger = LoggerFactory.getLogger(CarLinkDataSourceMock::class.java)

    private val carInfoDB = mutableListOf<CarInfo>()

//    override fun getCarInfo(brand: String, model: String): CarInfo? {
//        return carInfoDB.find { it.brand == brand && it.model == model }
//    }
//
//    override fun addCarInfo(info: CarInfo) {
//        if (carInfoDB.contains(info)) {
//            carInfoDB.replaceAll {
//                if (it.brand == info.brand && it.model == info.model) info
//                else it
//            }
//        } else {
//            carInfoDB.add(info)
//        }
//    }

    override fun getLinks(dealer: String): List<CarLink>? {
        TODO("Not yet implemented")
    }

    override fun addLink(link: CarLink) {
        TODO("Not yet implemented")
    }

}