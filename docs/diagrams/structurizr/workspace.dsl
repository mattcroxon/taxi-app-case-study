workspace "Leisure Lounges Taxi Integration" "Airport transportation integration between Leisure Lounges and Taxi services" {

    model {
        # Users
        traveler = person "Traveler" "Airport passenger using Leisure Lounges benefits and needing transportation" "User"
        
        # External Systems
        taxiApp = softwareSystem "TaxiService  Mobile App" "Native Taxi application for ride booking and management" "External System"
        taxiApi = softwareSystem "TaxiSerivce API Platform" "Taxi ride request, pricing, and management APIs" "External System"
        flightDataSystem = softwareSystem "Flight Data Provider" "Real-time flight information, delays, and gate updates" "External System"
        paymentGateway = softwareSystem "Payment Gateway" "Secure payment processing for ride bookings" "External System"
        
        # Core System
        leisureLoungeSystem = softwareSystem "Leisure Lounges Integration Platform" "Enhanced Leisure Lounges system with intelligent Taxi integration" {
            description "Provides flight-aware transportation recommendations and seamless booking experience"
            
            # Mobile Application
            mobileApp = container "Leisure Lounges Mobile App" "Enhanced mobile application with flight context and Taxi integration capabilities" "Mobile App"
            
            # Backend Services
            backendServices = container "Leisure Lounges Backend" "Core Leisure Lounges services with flight intelligence and integration capabilities" "Backend Services"
            flightInformationService = container "Flight Information Service" "Retrieves flight departure and arrival times" "Service" {
                # Core Components
                flightDataIngestion = component "Flight Data Ingestion" "Collects and validates real-time flight information" "Data Ingestion"
                cacheManager = component "Cache Manager" "Caches flight data and timing calculations" "Cache Layer"
                flightInformationAPI = component "Flight Information API" "RESTful API exposing flight timing data" "API"
            }
            taxiIntegrationService = container "Taxi Integration Service" "Handles Taxi API calls, ride orchestration, and booking management" "Service"
            deepLinkHandler = container "Deep Link Handler" "Manages seamless handoffs to/from Taxi app with context preservation" "Service"
            
            # Integration Layer
            rideOrchestrationAPI = container "Ride Orchestration API" "Manages ride booking lifecycle and coordinates between systems" "API Gateway"
            contextPreservationService = container "Context Preservation Service" "Maintains user state and booking context across app transitions" "Service"
            notificationHub = container "Notification Hub" "Provides real-time updates and status notifications across platforms" "Service"
        }
        
        # User Relationships
        traveler -> mobileApp "Views flight details, requests rides, receives recommendations"
        traveler -> taxiApp "Completes ride booking and tracks journey"
        
        # Mobile App Relationships
        mobileApp -> backendServices "Communicates with core services" "HTTPS/REST"
        mobileApp -> rideOrchestrationAPI "Requests rides and booking services" "HTTPS/REST"
        mobileApp -> taxiApp "Deep links with booking context" "Deep Link Protocol"
        
        # Backend Service Relationships
        backendServices -> flightInformationService "Retrieves flight timing intelligence" "Internal API"
        backendServices -> taxiIntegrationService "Accesses Taxi integration capabilities" "Internal API"
        backendServices -> deepLinkHandler "Manages app transition context" "Internal API"
        
        # Integration Layer Relationships
        flightInformationService -> rideOrchestrationAPI "Provides optimal timing recommendations" "HTTPS/REST"
        taxiIntegrationService -> taxiApi "Requests estimates, creates bookings, retrieves status" "HTTPS/REST API"
        taxiIntegrationService -> rideOrchestrationAPI "Coordinates ride booking lifecycle" "HTTPS/REST"
        deepLinkHandler -> contextPreservationService "Preserves user state across transitions" "HTTPS/REST"
        rideOrchestrationAPI -> contextPreservationService "Maintains booking context" "HTTPS/REST"
        rideOrchestrationAPI -> notificationHub "Sends status updates and notifications" "HTTPS/REST"
        
        # Flight Information Service Component Relationships
        flightDataIngestion -> flightDataSystem "Fetches real-time flight data" "HTTPS/REST"
        cacheManager -> flightInformationAPI "Provides cached data" "Internal"
        flightInformationAPI -> backendServices "Exposes flight timing data" "HTTPS/REST"
        flightInformationAPI -> rideOrchestrationAPI "Provides flight arrival / departure details" "HTTPS/REST"

        # External System Relationships
        notificationHub -> mobileApp "Pushes real-time updates" "Push Notifications"
        taxiApi -> notificationHub "Sends ride status updates" "Webhooks"
        taxiApp -> taxiApi "Manages ride lifecycle and driver communication"
        rideOrchestrationAPI -> paymentGateway "Processes ride payments" "HTTPS/REST"
    }

    views {
        systemContext leisureLoungeSystem "SystemContext" {
            include *
            animation {
                traveler
                leisureLoungeSystem
                taxiApp taxiApi
                flightDataSystem paymentGateway
            }
            description "System context showing Leisure Lounges integration with Taxi ecosystem for airport transportation"
            title "Leisure Lounges Taxi Integration - Context Diagram"
        }

        container leisureLoungeSystem "ContainerDiagram" {
            include *
            animation {
                traveler
                mobileApp
                backendServices flightInformationService taxiIntegrationService deepLinkHandler
                rideOrchestrationAPI contextPreservationService notificationHub
                taxiApp taxiApi flightDataSystem paymentGateway
            }
            autoLayout
            description "Container diagram showing the internal structure of Leisure Lounges Integration Platform with flight-aware Taxi integration"
            title "Leisure Lounges Taxi Integration - Container Diagram"
        }

        component flightInformationService "FlightContextComponents" {
            include *
            animation {
                flightDataIngestion
                cacheManager
                flightInformationAPI
                flightDataSystem
                backendServices rideOrchestrationAPI
            }
            autoLayout
            description "Component diagram showing the simplified internal structure of the Flight Information Service"
            title "Flight Information Service - Component Diagram"
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