package de.bitb.main_service.controller.car_info

import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.jsonschema.JsonSchema
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.core.MethodParameter
import org.springframework.core.io.support.ResourcePatternResolver
import org.springframework.web.bind.support.WebDataBinderFactory
import org.springframework.web.context.request.NativeWebRequest
import org.springframework.web.method.support.HandlerMethodArgumentResolver
import org.springframework.web.method.support.ModelAndViewContainer

//class CarInfoSchemaValidator @Autowired constructor(
//    val objectMapper: ObjectMapper,
//    val  resourcePatternResolve : ResourcePatternResolver,
//) :
//    HandlerMethodArgumentResolver {
//
////    val schemaCache:  Map<String, JsonSchema> = {}
//
//    override fun supportsParameter(parameter: MethodParameter): Boolean {
//        TODO("Not yet implemented")
//    }
//
//    override fun resolveArgument(
//        parameter: MethodParameter,
//        mavContainer: ModelAndViewContainer?,
//        webRequest: NativeWebRequest,
//        binderFactory: WebDataBinderFactory?
//    ): Any? {
//        TODO("Not yet implemented")
//    }
//}

//public class JsonSchemaValidatingArgumentResolver implements HandlerMethodArgumentResolver {
//
//    private final ObjectMapper objectMapper;
//    private final ResourcePatternResolver resourcePatternResolver;
//    private final Map<String, JsonSchema> schemaCache;
//
//    public JsonSchemaValidatingArgumentResolver(ObjectMapper objectMapper, ResourcePatternResolver resourcePatternResolver) {
//        this.objectMapper = objectMapper;
//        this.resourcePatternResolver = resourcePatternResolver;
//        this.schemaCache = new ConcurrentHashMap<>();
//    }
//
//    @Override
//    public boolean supportsParameter(MethodParameter methodParameter) {
//        return methodParameter.getParameterAnnotation(ValidJson.class) != null;
//    }
//
//    ...
//}