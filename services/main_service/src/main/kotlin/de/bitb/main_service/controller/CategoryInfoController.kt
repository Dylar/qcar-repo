package de.bitb.main_service.controller

import de.bitb.main_service.exceptions.CategoryInfoException
import de.bitb.main_service.models.CategoryInfo
import de.bitb.main_service.service.CategoryInfoService
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(CATEGORY_INFO_URL_V1)
class CategoryInfoController(private val service: CategoryInfoService) {

    @ExceptionHandler(CategoryInfoException::class)
    fun handleException(e: CategoryInfoException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.BAD_REQUEST)

    @ExceptionHandler(CategoryInfoException.UnknownCategoryException::class)
    fun handleException(e: CategoryInfoException.UnknownCategoryException): ResponseEntity<String> =
        ResponseEntity(e.message, HttpStatus.NOT_FOUND)

    @GetMapping("/{brand}/{model}/{name}")
    fun getCategoryInfo(
        @PathVariable brand: String,
        @PathVariable model: String,
        @PathVariable name: String
    ): CategoryInfo = service.getCategoryInfo(brand, model, name)

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun addCategoryInfo(@RequestBody info: CategoryInfo) = service.addCategoryInfo(info)

}