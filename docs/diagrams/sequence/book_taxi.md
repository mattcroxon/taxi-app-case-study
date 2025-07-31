```mermaid
      participant User
      participant PriorityPassApp as Priority Pass App
      participant FlightContextService as Flight Context Service
      participant UberIntegrationService as Uber Integration Service
      participant UberAPI as Uber API v1.2
      participant UberApp as Uber App
      participant NotificationHub as Notification Hub

      User->>PriorityPassApp: Open flight details
      PriorityPassApp->>FlightContextService: Get flight information
      FlightContextService->>FlightContextService: Calculate optimal departure time (Flight arrival - 45min)
      FlightContextService-->>PriorityPassApp: Return recommended pickup time

      User->>PriorityPassApp: Request taxi booking
      PriorityPassApp->>UberIntegrationService: Initiate ride request

      UberIntegrationService->>UberAPI: GET /products
      UberAPI-->>UberIntegrationService: Available ride products

      UberIntegrationService->>UberAPI: POST /requests/estimate
      UberAPI-->>UberIntegrationService: Upfront fare estimate

      UberIntegrationService-->>PriorityPassApp: Show fare and timing options
      PriorityPassApp-->>User: Display "Book Uber for [time] (45 min before flight)"

      User->>PriorityPassApp: Confirm booking
      PriorityPassApp->>UberIntegrationService: Create scheduled ride

      UberIntegrationService->>UberAPI: POST /v1.2/requests (with scheduled pickup)
      UberAPI-->>UberIntegrationService: Booking reference

      UberIntegrationService->>PriorityPassApp: Generate deep link with context
      PriorityPassApp->>UberApp: Deep link handoff (pickup location + destination)

      UberApp->>User: Native Uber booking completion
      User->>UberApp: Complete booking in Uber app

      UberApp->>UberAPI: Finalize ride booking
      UberAPI->>NotificationHub: Booking status update
      NotificationHub->>PriorityPassApp: Real-time status update
      PriorityPassApp->>User: Show booking confirmation in Priority Pass

      Note over UberApp, NotificationHub: Ongoing ride tracking
      UberAPI->>NotificationHub: Driver assigned/En route/Arrived updates
      NotificationHub->>PriorityPassApp: Status updates
      PriorityPassApp->>User: Real-time ride status in trip summary
```