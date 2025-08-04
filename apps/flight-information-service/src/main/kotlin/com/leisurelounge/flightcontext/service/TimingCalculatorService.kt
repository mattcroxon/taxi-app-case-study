package com.leisurelounge.flightcontext.service

import com.leisurelounge.flightcontext.model.FlightInfo
import com.leisurelounge.flightcontext.model.FlightStatus
import com.leisurelounge.flightcontext.model.TimingRecommendation
import org.springframework.cache.annotation.Cacheable
import org.springframework.stereotype.Service
import java.time.LocalDateTime

@Service
class TimingCalculatorService {

    @Cacheable("timing-recommendations")
    fun calculateOptimalTiming(
        flightInfo: FlightInfo,
        pickupLocation: String,
        estimatedTravelTimeMinutes: Int = 30
    ): TimingRecommendation {
        
        val bufferTime = 45 // Standard 45-minute buffer before flight departure
        val effectiveDepartureTime = flightInfo.departure.estimatedTime ?: flightInfo.departure.scheduledTime
        
        // Calculate recommended pickup time
        val recommendedDepartureTime = effectiveDepartureTime
            .minusMinutes(bufferTime.toLong())
            .minusMinutes(estimatedTravelTimeMinutes.toLong())
        
        val reasoning = buildReasoningString(flightInfo, estimatedTravelTimeMinutes, bufferTime)
        
        return TimingRecommendation(
            flightNumber = flightInfo.flightNumber,
            recommendedDepartureTime = recommendedDepartureTime,
            pickupLocation = pickupLocation,
            estimatedTravelTime = estimatedTravelTimeMinutes,
            bufferTime = bufferTime,
            reasoning = reasoning
        )
    }
    
    private fun buildReasoningString(
        flightInfo: FlightInfo, 
        travelTime: Int, 
        buffer: Int
    ): String {
        val statusInfo = when (flightInfo.status) {
            FlightStatus.DELAYED -> " (accounting for delay)"
            FlightStatus.ON_TIME -> " (on schedule)"
            else -> ""
        }
        
        val departureTime = (flightInfo.departure.estimatedTime ?: flightInfo.departure.scheduledTime)
            .toLocalTime()
        
        return "Flight ${flightInfo.flightNumber} departs at $departureTime$statusInfo. " +
                "Allowing ${buffer}min buffer + ${travelTime}min travel time."
    }
    
    fun estimateTravelTime(origin: String, destination: String): Int {
        // Mock travel time estimation - in real implementation would use maps API
        return when {
            origin.contains("downtown", ignoreCase = true) -> 45
            origin.contains("hotel", ignoreCase = true) -> 35
            origin.contains("terminal", ignoreCase = true) -> 15
            else -> 30
        }
    }
}