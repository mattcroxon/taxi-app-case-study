package com.prioritypass.flightcontext.model

import java.time.LocalDateTime

data class FlightInfo(
    val flightNumber: String,
    val airline: String,
    val departure: FlightLeg,
    val arrival: FlightLeg,
    val status: FlightStatus,
    val aircraft: String? = null
)

data class FlightLeg(
    val airport: Airport,
    val scheduledTime: LocalDateTime,
    val estimatedTime: LocalDateTime? = null,
    val actualTime: LocalDateTime? = null,
    val terminal: String? = null,
    val gate: String? = null
)

data class Airport(
    val code: String,
    val name: String,
    val city: String,
    val country: String,
    val timeZone: String
)

enum class FlightStatus {
    SCHEDULED,
    DELAYED,
    ON_TIME,
    BOARDING,
    DEPARTED,
    ARRIVED,
    CANCELLED
}

data class TimingRecommendation(
    val flightNumber: String,
    val recommendedDepartureTime: LocalDateTime,
    val pickupLocation: String,
    val estimatedTravelTime: Int, // minutes
    val bufferTime: Int = 45, // minutes
    val reasoning: String
)