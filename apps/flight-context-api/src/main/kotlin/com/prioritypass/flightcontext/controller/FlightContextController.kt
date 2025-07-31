package com.prioritypass.flightcontext.controller

import com.prioritypass.flightcontext.model.FlightInfo
import com.prioritypass.flightcontext.model.TimingRecommendation
import com.prioritypass.flightcontext.service.FlightDataService
import com.prioritypass.flightcontext.service.TimingCalculatorService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import jakarta.validation.constraints.NotBlank

@RestController
@RequestMapping("/api/v1/flight-context")
@CrossOrigin(origins = ["*"])
class FlightContextController(
    private val flightDataService: FlightDataService,
    private val timingCalculatorService: TimingCalculatorService
) {

    @GetMapping("/flights/{flightNumber}")
    fun getFlightInfo(@PathVariable flightNumber: String): ResponseEntity<FlightInfo> {
        if (!flightDataService.validateFlightNumber(flightNumber)) {
            return ResponseEntity.badRequest().build()
        }
        
        val flightInfo = flightDataService.getFlightInfo(flightNumber)
        return if (flightInfo != null) {
            ResponseEntity.ok(flightInfo)
        } else {
            ResponseEntity.notFound().build()
        }
    }

    @PostMapping("/timing-recommendation")
    fun getTimingRecommendation(@RequestBody request: TimingRequest): ResponseEntity<TimingRecommendation> {
        if (!flightDataService.validateFlightNumber(request.flightNumber)) {
            return ResponseEntity.badRequest().build()
        }
        
        val flightInfo = flightDataService.getFlightInfo(request.flightNumber)
            ?: return ResponseEntity.notFound().build()
        
        val travelTime = request.estimatedTravelTimeMinutes 
            ?: timingCalculatorService.estimateTravelTime(request.pickupLocation, "airport")
        
        val recommendation = timingCalculatorService.calculateOptimalTiming(
            flightInfo = flightInfo,
            pickupLocation = request.pickupLocation,
            estimatedTravelTimeMinutes = travelTime
        )
        
        return ResponseEntity.ok(recommendation)
    }

    @GetMapping("/health")
    fun healthCheck(): ResponseEntity<Map<String, String>> {
        return ResponseEntity.ok(mapOf(
            "status" to "UP",
            "service" to "Flight Context API",
            "version" to "1.0.0"
        ))
    }
}

data class TimingRequest(
    @field:NotBlank
    val flightNumber: String,
    @field:NotBlank
    val pickupLocation: String,
    val estimatedTravelTimeMinutes: Int? = null
)