workspace "Priority Pass Uber Integration" "Airport transportation integration between Priority Pass and Uber services" {

    model {
        # Users
        traveler = person "Traveler" "Airport passenger using Priority Pass benefits and needing transportation" "User"
        
        # External Systems
        uberApp = softwareSystem "Uber Mobile App" "Native Uber application for ride booking and management" "External System"
        uberAPI = softwareSystem "Uber API Platform" "Uber's ride request, pricing, and management APIs" "External System"
        flightDataSystem = softwareSystem "Flight Data Provider" "Real-time flight information, delays, and gate updates" "External System"
        paymentGateway = softwareSystem "Payment Gateway" "Secure payment processing for ride bookings" "External System"
        
        # Core System
        priorityPassSystem = softwareSystem "Priority Pass Integration Platform" "Enhanced Priority Pass system with intelligent Uber integration" {
            description "Provides flight-aware transportation recommendations and seamless booking experience"
            
            # Mobile Application
            mobileApp = container "Priority Pass Mobile App" "Enhanced mobile application with flight context and Uber integration capabilities" "Mobile App"
            
            # Backend Services
            backendServices = container "Priority Pass Backend" "Core Priority Pass services with flight intelligence and integration capabilities" "Backend Services"
            flightContextService = container "Flight Context Service" "Processes flight data to calculate optimal departure times" "Service" {
                # Core Components
                flightDataIngestion = component "Flight Data Ingestion" "Collects and validates real-time flight information" "Data Ingestion"
                timingCalculator = component "Timing Calculator" "Calculates optimal departure times based on flight schedules" "Calculation Engine"
                cacheManager = component "Cache Manager" "Caches flight data and timing calculations" "Cache Layer"
                flightContextAPI = component "Flight Context API" "RESTful API exposing flight timing data" "API"
            }
            uberIntegrationService = container "Uber Integration Service" "Handles Uber API calls, ride orchestration, and booking management" "Service"
            deepLinkHandler = container "Deep Link Handler" "Manages seamless handoffs to/from Uber app with context preservation" "Service"
            
            # Integration Layer
            rideOrchestrationAPI = container "Ride Orchestration API" "Manages ride booking lifecycle and coordinates between systems" "API Gateway"
            contextPreservationService = container "Context Preservation Service" "Maintains user state and booking context across app transitions" "Service"
            notificationHub = container "Notification Hub" "Provides real-time updates and status notifications across platforms" "Service"
        }
        
        # User Relationships
        traveler -> mobileApp "Views flight details, requests rides, receives recommendations"
        traveler -> uberApp "Completes ride booking and tracks journey"
        
        # Mobile App Relationships
        mobileApp -> backendServices "Communicates with core services" "HTTPS/REST"
        mobileApp -> rideOrchestrationAPI "Requests rides and booking services" "HTTPS/REST"
        mobileApp -> uberApp "Deep links with booking context" "Deep Link Protocol"
        
        # Backend Service Relationships
        backendServices -> flightContextService "Retrieves flight timing intelligence" "Internal API"
        backendServices -> uberIntegrationService "Accesses Uber integration capabilities" "Internal API"
        backendServices -> deepLinkHandler "Manages app transition context" "Internal API"
        
        # Integration Layer Relationships
        flightContextService -> rideOrchestrationAPI "Provides optimal timing recommendations" "HTTPS/REST"
        uberIntegrationService -> uberAPI "Requests estimates, creates bookings, retrieves status" "HTTPS/REST API"
        uberIntegrationService -> rideOrchestrationAPI "Coordinates ride booking lifecycle" "HTTPS/REST"
        deepLinkHandler -> contextPreservationService "Preserves user state across transitions" "HTTPS/REST"
        rideOrchestrationAPI -> contextPreservationService "Maintains booking context" "HTTPS/REST"
        rideOrchestrationAPI -> notificationHub "Sends status updates and notifications" "HTTPS/REST"
        
        # Flight Context Service Component Relationships
        flightDataIngestion -> flightDataSystem "Fetches real-time flight data" "HTTPS/REST"
        flightDataIngestion -> timingCalculator "Sends validated flight data" "Internal"
        timingCalculator -> cacheManager "Stores timing calculations" "Internal"
        cacheManager -> flightContextAPI "Provides cached data" "Internal"
        flightContextAPI -> backendServices "Exposes flight timing data" "HTTPS/REST"
        flightContextAPI -> rideOrchestrationAPI "Provides timing calculations" "HTTPS/REST"

        # External System Relationships
        notificationHub -> mobileApp "Pushes real-time updates" "Push Notifications"
        uberAPI -> notificationHub "Sends ride status updates" "Webhooks"
        uberApp -> uberAPI "Manages ride lifecycle and driver communication"
        rideOrchestrationAPI -> paymentGateway "Processes ride payments" "HTTPS/REST"
    }

    views {
        systemContext priorityPassSystem "SystemContext" {
            include *
            animation {
                traveler
                priorityPassSystem
                uberApp uberAPI
                flightDataSystem paymentGateway
            }
            autoLayout
            description "System context showing Priority Pass integration with Uber ecosystem for airport transportation"
            title "Priority Pass Uber Integration - Context Diagram"
        }

        container priorityPassSystem "ContainerDiagram" {
            include *
            animation {
                traveler
                mobileApp
                backendServices flightContextService uberIntegrationService deepLinkHandler
                rideOrchestrationAPI contextPreservationService notificationHub
                uberApp uberAPI flightDataSystem paymentGateway
            }
            autoLayout
            description "Container diagram showing the internal structure of Priority Pass Integration Platform with flight-aware Uber integration"
            title "Priority Pass Uber Integration - Container Diagram"
        }

        component flightContextService "FlightContextComponents" {
            include *
            animation {
                flightDataIngestion
                timingCalculator
                cacheManager
                flightContextAPI
                flightDataSystem
                backendServices rideOrchestrationAPI
            }
            autoLayout
            description "Component diagram showing the simplified internal structure of the Flight Context Service"
            title "Flight Context Service - Component Diagram"
        }

        styles {
            element "Person" {
                color #ffffff
                fontSize 22
                shape Person
            }
            element "External System" {
                background #999999
                color #ffffff
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Mobile App" {
                background #2e7d32
                color #ffffff
                shape MobileDevicePortrait
            }
            element "Backend Services" {
                background #1565c0
                color #ffffff
            }
            element "Service" {
                background #5e35b1
                color #ffffff
            }
            element "API Gateway" {
                background #e65100
                color #ffffff
            }
            element "Data Ingestion" {
                background #795548
                color #ffffff
            }
            element "Processing Engine" {
                background #607d8b
                color #ffffff
            }
            element "Calculation Engine" {
                background #455a64
                color #ffffff
            }
            element "Cache Layer" {
                background #ff9800
                color #ffffff
            }
            element "API" {
                background #9c27b0
                color #ffffff
            }
            relationship "Relationship" {
                dashed false
            }
        }
    }

}