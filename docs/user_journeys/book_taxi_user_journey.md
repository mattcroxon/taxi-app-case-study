# Book Taxi User Journey

## Home/Lounge List

**State:** `currentView: 'home'`

- User sees list of available lounges
- Can select a lounge which navigates to lounge details

## Lounge Details

**State:** `currentView: 'lounge-details'`

- User sees detailed info about selected lounge
- Can click "Book" to go to booking flow
- Can go back to home

## Booking Flow

**State:** `currentView: 'booking'`

- User fills out lounge booking details (date, time, guests, duration)
- At the end, user has two options:
  - Complete booking without taxi (calls `onBookingComplete`)
  - Add taxi service (calls `onTaxiService`)
- Both options add the lounge booking to completed bookings

## Taxi Booking

**State:** `currentView: 'taxi-booking'` - if user chose taxi service

- User selects trip type (arrival vs departure) - for this case, arrival
- User enters flight information (airline, flight number, date)
- System fetches flight details (mock arrival time, terminal, gate)
- User adjusts airport exit time using slider (15min-3h)
- System calculates pickup time = flight arrival + exit buffer
- User enters destination address
- User selects vehicle type
- User enters contact details
- Clicks "View Taxi Quote"

## Taxi Quote

**State:** `currentView: 'taxi-quote'`

- Shows complete trip overview with pickup/destination
- Shows flight details and timing calculation
- Shows cost breakdown
- Shows service guarantees
- User confirms booking

## Booking Confirmation

The final stage involves finalizing the taxi reservation. After reviewing the comprehensive trip details, the user receives a unique booking confirmation. This screen displays critical information including:

- Specific booking ID
- Comprehensive driver details
- Complete breakdown of the trip and flight specifics
- Option to return to the home screen, completing the entire booking journey seamlessly

## Navigation

The navigation remains dynamic, with the `currentView` state controlling transitions and bottom navigation enabling quick access to different app sections like Home, Lounges, Bookings, and Profile.