package de.bitb.main_service.controller.car_info

import de.bitb.main_service.models.CarInfo
import de.bitb.main_service.models.validateCarInfo
import org.springframework.stereotype.Component
import org.springframework.validation.Errors
import org.springframework.validation.Validator

//TODO make the validation ?
//@Component("beforeCreateWebsiteUserValidator")
class TestCarInfoValidator : Validator {
    override fun supports(clazz: Class<*>): Boolean = CarInfo::class.java.isAssignableFrom(clazz)

    override fun validate(obj: Any, errors: Errors) {
        val info = obj as CarInfo
        validateCarInfo(info)
//        val name = pet.name
//        // name validation
//        if (!StringUtils.hasLength(name)) {
//            errors.rejectValue("name", REQUIRED, REQUIRED)
//        }
//
//        // type validation
//        if (pet.isNew && pet.type == null) {
//            errors.rejectValue("type", REQUIRED, REQUIRED)
//        }
//
//        // birth date validation
//        if (pet.birthDate == null) {
//            errors.rejectValue("birthDate", REQUIRED, REQUIRED)
//        }
    }
}
