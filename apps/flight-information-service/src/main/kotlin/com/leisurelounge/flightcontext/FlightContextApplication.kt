package com.leisurelounge.flightcontext

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.cache.annotation.EnableCaching

@SpringBootApplication
@EnableCaching
class FlightContextApplication

fun main(args: Array<String>) {
    runApplication<FlightContextApplication>(*args)
}