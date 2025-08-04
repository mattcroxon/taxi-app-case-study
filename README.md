
## Getting started 

The following solution architecture contains: 
- C4 diagrams, detailing the Context, Container and Component views of the 'Leisure Lounge' travel lounge mobile application, taking requirements specified in the [Case Study](./instructions.md) into consideration.
- OpenAPI specifications for both the LoungePass API, and the Taxi API 
- Sequence diagrams detailing the interactions to make a taxi booking 
- Web / mobile application wireframes, detailing the customer journey of adding a Taxi add on services to an Leisure Lounge booking
- A Kotlin based 'Flight Information Service' example application, which mocks the data returned from the external Flight Information service providers

## Viewing the solution artefacts

From the root folder, run `docker compose up`
- The C4 documentation documentation (served by Structurizr), will be available at [http://localhost:8080](http://localhost:8080)
- The PlantUML server, containing the sequence diagrams, will be available at [http://localhost:8081](http://localhost:8081). Currently, you will need to copy/paste the markdown files into the PlantUML user interface
- The Taxi Service API documentation (Swagger UI) will be available at [http://localhost:8082](http://localhost:8082)
- The Leisure Lounges API documentation (Swagger UI) will be available at [http://localhost:8083](http://localhost:8083)
- The Flight Information Service can be invoked, returning mocked data, through the following: 
```bash
curl -X POST http://localhost:9000/api/v1/flight-context/timing-recommendation \
  -H "Content-Type: application/json" \
  -d '{
    "flightNumber": "BA123",
    "pickupLocation": "downtown hotel"
  }'
```

### C4 Diagrams 
The sequence diagrams are stored as a Structurizr model in `/docs/diagrams/structurizr/workspace.dsl`. To view the diagrams in the server:
1. Start the services: `docker compose up`
2. Open the PlantUML server at [http://localhost:8081](http://localhost:8081)

### OpenAPI Swagger Developer Documentation
The API specifications are stored as OpenAPI YAML files in `/docs/api/`. To view them:

1. Start the services: `docker compose up`
2. Open the Taxi Service API documentation at [http://localhost:8082](http://localhost:8082)
3. Open the Leisure Lounges API documentation at [http://localhost:8083](http://localhost:8083)

**Available API specifications:**
- `taxi-api-openapi.yaml` - Taxi Service API for ride booking and management
- `leisure-lounges-api-openapi.yaml` - Leisure Lounges API for lounge access and booking 

### Sequence Diagrams
The sequence diagrams are stored as PlantUML files in `/docs/diagrams/sequence/`. To view them:

1. Start the services: `docker compose up`
2. Open the PlantUML server at [http://localhost:8081](http://localhost:8081)

**Available sequence diagrams:**
- `book_taxi.md` - Taxi booking flow with flight context integration

### Application Wireframes 
The wireframes have been generated using Figma Make, and are available [here](https://www.figma.com/make/Qrg4u1OrfrhyVTO3C4kQ5e/Lounge-Pass-Mobile-App?node-id=0-1&p=f&t=wZr9G5zIGSWqWhqc-0&fullscreen=1)

A supporting document, describing the user journey can be found [here](./docs/user_journeys/book_taxi_user_journey.md) 

## Problem definition

### Context 
Leisure Lounges members frequently travel through airports and require seamless transportation to/from airport locations. Currently, travelers must manually coordinate ride booking with their flight schedules, often resulting in:
- Suboptimal taxi departure timing leading to missed flights or extended wait times upon arrival
- Fragmented user experience switching between multiple apps
- Lack of flight-aware transportation recommendations
- No integration between lounge access and transportation services

### Key objective
Design and implement an intelligent transportation integration that:
- Automatically retrieves real-time flight data to inform taxi journey timings
- Provides seamless booking experience within the Leisure Lounges ecosystem
- Enables lounge access booking for taxi applications and partners
- Maintains context preservation across app transitions
- Delivers real-time ride tracking and status updates

### Business Constraints
- **Integration Complexity**: Must work with existing Leisure Lounges infrastructure and third-party taxi APIs
- **User Experience**: Cannot disrupt current Leisure Lounges app workflows or require significant user behavior changes
- **Data Privacy**: Must comply with GDPR and aviation data regulations when processing flight information
- **Scalability**: Solution must handle varying airport sizes and traffic patterns globally
- **Partnership Requirements**: Must support multiple taxi service providers and enable partner integrations
- **Revenue Model**: Should maintain existing Leisure Lounges business model while enabling new revenue streams through transportation partnerships

### System Design

#### Overview
The proposed solution implements a **Flight-Aware Transportation Integration Platform** that extends Leisure Lounges capabilities with intelligent ride booking and lounge access services. The architecture follows a microservices approach with the following key components:

**Core Services:**
- **Flight Information Service**: Processes real-time flight data to calculate optimal departure times (45 minutes before flight arrival)
- **Taxi Integration Service**: Manages third-party taxi API integration for ride booking and status tracking
- **Leisure Lounges API**: Enables partner applications to discover and book lounge access for travelers
- **Deep Link Handler**: Facilitates seamless app transitions while preserving booking context
- **Notification Hub**: Provides real-time updates across all connected applications

**Key Design Principles:**
- **Orchestration over Eventing**: We have decided to follow an Orchestrator pattern to reduce infrastructure concerns relating to setting managing underlying event bus infrastructure, at least for the initial MVP
- **Context Preservation**: Maintains user state and booking information across app boundaries
- **Flight Intelligence**: Leverages flight data to provide proactive transportation recommendations
- **Partner Enablement**: Opens lounge booking capabilities to taxi applications and other partners
- **Real-time Updates**: Ensures all stakeholders receive timely status notifications

**Integration Flow:**
1. User views flight details in Leisure Lounges app
2. User selects  taxi departure time based on flight schedule
3. User initiates ride booking through Leisure Lounges interface
4. Deep link handoff to taxi app with preserved context
5. Continuous status synchronization between all applications
6. Optional lounge booking available through taxi partner applications

#### Architecture Diagrams
- [Context Diagram - C1](http://localhost:8080/workspace/diagrams#SystemContext)

- [Container Diagram - C2](http://localhost:8080/workspace/diagrams#ContainerDiagram)

- [Container Diagram - C3](http://localhost:8080/workspace/diagrams#FlightContextComponents)

## Considerations 

### Omissions 
- **Multi-language Support**: The current design doesn't specify localization for international airports and different languages
- **Offline Functionality**: No consideration for scenarios where network connectivity is limited or unavailable
- **Payment Processing**: While the APIs reference payment gateways, detailed payment flow and error handling are not fully specified
- **Advanced Analytics**: Missing detailed tracking and analytics for user behavior, booking patterns, and system performance metrics
- **Comprehensive Error Recovery**: Limited specification of fallback mechanisms when external services (flight data, taxi APIs) are unavailable
- **Mobile Platform Specifics**: Deep linking implementation details for different mobile platforms (iOS/Android) are not fully elaborated
- **Data Retention Policies**: No specification of how long user data, booking history, and flight information should be retained

### Trade offs 
- **Real-time vs. Batch Processing**: Chose real-time flight data processing for accuracy but at the cost of increased system complexity and potential latency
- **Monolithic vs. Microservices**: Selected microservices architecture for scalability and flexibility, trading simplicity for operational complexity
- **Deep Linking vs. Embedded Experience**: Opted for deep linking to taxi apps rather than embedded booking to maintain partner relationships but sacrificing full control over user experience
- **API Complexity vs. Flexibility**: Designed comprehensive APIs with extensive schemas to support various use cases, trading simplicity for future extensibility
- **Caching Strategy**: Implemented caching for performance but introduced data consistency challenges and cache invalidation complexity
- **Partner Integration**: Chose to integrate with existing taxi APIs rather than building proprietary transportation network, limiting control but accelerating time-to-market

### Deferred features & shortcuts
- **Machine Learning Optimization**: Intelligent timing calculations currently use simple rules (45 minutes before flight) rather than ML-based predictions considering traffic patterns, weather, and historical data
- **Multi-modal Transportation**: Focus limited to taxi services only; integration with public transit, parking, or other transportation modes deferred
- **Dynamic Pricing Integration**: Basic fare estimation implemented without surge pricing optimization or dynamic pricing negotiations
- **Advanced Booking Management**: Features like booking modifications, group bookings, and corporate account management simplified for initial implementation
- **Comprehensive Testing Strategy**: API specifications provided without detailed integration testing, load testing, and failure scenario validation
- **Security Implementation**: While authentication schemes are specified, detailed security measures like rate limiting, fraud detection, and data encryption specifics are deferred
- **Operational Monitoring**: Basic error responses defined but comprehensive monitoring, alerting, and operational dashboards not fully specified
- **Partner Onboarding**: Simplified partner integration process without comprehensive partner management, SLA monitoring, and revenue sharing mechanisms

## GenAI Technologies Used

This solution has been developed using several Generative AI technologies to accelerate development and ensure comprehensive documentation:

**Claude Code** was extensively used throughout the project for multiple aspects of the solution architecture. It assisted in creating detailed technical documentation, generating comprehensive C4 architectural diagrams using Structurizr DSL, and developing robust OpenAPI schema specifications for both the Taxi Service API and Leisure Lounges API. Additionally, Claude Code was instrumental in implementing the reference Kotlin Flight Information Service application, ensuring proper Spring Boot configuration, REST endpoint implementation, and mock data generation for testing scenarios.

**Figma Make** was utilized to generate professional wireframes for the Leisure Lounge mobile application user interface. These wireframes detail the complete customer journey for adding taxi add-on services to lounge bookings, providing clear visual representations of the user experience flow and interface design patterns.
