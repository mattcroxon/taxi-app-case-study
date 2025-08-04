# Flight Information API

A Kotlin-based REST API service that provides flight timing intelligence for the Leisure Lounges taxi integration system.

## Features

- **Flight Information Retrieval**: Get real-time flight data by flight number
- **Caching**: High-performance caching for flight data and calculations
- **Mock Data**: Includes sample flight data for testing

## API Endpoints

### Health Check
```
GET /api/v1/flight-context/health
```

### Get Flight Information
```
GET /api/v1/flight-context/flights/{flightNumber}
```

Example:
```bash
curl http://localhost:9000/api/v1/flight-context/flights/BA123
```

### Get Timing Recommendation
```
POST /api/v1/flight-context/timing-recommendation
Content-Type: application/json

{
  "flightNumber": "BA123",
  "pickupLocation": "downtown hotel",
  "estimatedTravelTimeMinutes": 30
}
```

Example:
```bash
curl -X POST http://localhost:9000/api/v1/flight-context/timing-recommendation \
  -H "Content-Type: application/json" \
  -d '{
    "flightNumber": "BA123",
    "pickupLocation": "downtown hotel"
  }'
```

## Sample Flight Data

The API includes mock data for testing:

- **BA123**: British Airways LHR→JFK (delayed)
- **UA456**: United Airlines SFO→LAX (on time)

## Running the Application

### Prerequisites
- Java 17+
- Gradle (or use the included wrapper)

### Start the service
```bash
./gradlew bootRun
```

The API will be available at `http://localhost:9000`

### Build JAR
```bash
./gradlew build
java -jar build/libs/flight-context-api-1.0.0.jar
```

## Configuration

The service runs on port 8080 by default. Configuration can be modified in `src/main/resources/application.yml`.

## Architecture

The service follows the component structure defined in the C4 diagram:

- **Flight Data Ingestion**: Validates and retrieves flight information
- **Timing Calculator**: Computes optimal departure times with configurable buffers
- **Cache Manager**: Provides high-performance caching via Spring Cache
- **Flight Context API**: RESTful endpoints for external integration