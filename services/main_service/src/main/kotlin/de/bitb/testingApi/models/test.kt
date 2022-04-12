package de.bitb.testingApi.models

import com.fasterxml.jackson.annotation.JsonIgnoreProperties

@JsonIgnoreProperties(ignoreUnknown = true)
data class Quote(val type: String?, val value: Value?) {
}

data class Value(val id: String, val quote: String)
