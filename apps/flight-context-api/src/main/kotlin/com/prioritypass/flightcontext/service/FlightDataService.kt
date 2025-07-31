package com.prioritypass.flightcontext.service

import com.prioritypass.flightcontext.model.*
import org.springframework.cache.annotation.Cacheable
import org.springframework.stereotype.Service
import java.time.LocalDateTime
import java.time.ZoneId

@Service
class FlightDataService {

    @Cacheable("flights")
    fun getFlightInfo(flightNumber: String): FlightInfo? {
        // Mock flight data - in real implementation would call external flight API
        return when (flightNumber.uppercase()) {
            "BA123" -> FlightInfo(
                flightNumber = "BA123",
                airline = "British Airways",
                departure = FlightLeg(
                    airport = Airport("LHR", "Heathrow", "London", "UK", "Europe/London"),
                    scheduledTime = LocalDateTime.now().plusHours(2),
                    estimatedTime = LocalDateTime.now().plusHours(2).plusMinutes(15),
                    terminal = "5",
                    gate = "A12"
                ),
                arrival = FlightLeg(
                    airport = Airport("JFK", "John F. Kennedy", "New York", "USA", "America/New_York"),
                    scheduledTime = LocalDateTime.now().plusHours(10),
                    estimatedTime = LocalDateTime.now().plusHours(10).plusMinutes(15),
                    terminal = "7"
                ),
                status = FlightStatus.DELAYED,
                aircraft = "Boeing 777"
            )
            "UA456" -> FlightInfo(
                flightNumber = "UA456",
                airline = "United Airlines",
                departure = FlightLeg(
                    airport = Airport("SFO", "San Francisco International", "San Francisco", "USA", "America/Los_Angeles"),
                    scheduledTime = LocalDateTime.now().plusHours(3),
                    terminal = "3",
                    gate = "B25"
                ),
                arrival = FlightLeg(
                    airport = Airport("LAX", "Los Angeles International", "Los Angeles", "USA", "America/Los_Angeles"),
                    scheduledTime = LocalDateTime.now().plusHours(4).plusMinutes(30),
                    terminal = "7"
                ),
                status = FlightStatus.ON_TIME,
                aircraft = "Airbus A320"
            )
            else -> null
        }
    }

    fun validateFlightNumber(flightNumber: String): Boolean {
        return flightNumber.matches(Regex("^[A-Z]{2}\\d{1,4}$"))
    }
}