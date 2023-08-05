## Setup Guide

Follow this steps to run this project locally
### Ruby version
2.7.2

### Rails version
5.2.8

### Start server api first
First make sure docker is installed and running on your machine. After that go to the server directory and run `docker compose build` after that run `docker compose up`

After that move to client directory and follow this:
### Install gems and dependencies

```
bundle install
```

run the following command to generate application.yml to store env
```
bundle exec figaro install
```

Add this ENV variable to application.yml and make sure this is in .gitignore

```
OPEN_EXCHANGE_RATES_APP_ID: 18df36775b104a8593d81efac1935fa0
BOOKINGS_SERVER_API_URL: http://localhost:9292/api/bookings
```
After that you just need to start server through this command:

```
rails s
```

The Client Application has a controller called PaymentsController, that is using a service for fetching payments and provides the following features:

## Calculate Amount with Fees
The calculate_amount_with_fees method calculates the amount with fees for different input ranges. This method can be accessed through the PaymentsController or the included PaymentCalculationsHelper module.

## Quality Check
The calculate_quality_check method performs quality checks on bookings based on the following criteria:

### Invalid Email:
Checks if the email is in a valid format.

### Duplicated Payment:
Checks if the payment reference is duplicated.

### Amount Threshold:
Checks if the amount with fees exceeds 1,000,000.

The quality check method can also be accessed through the PaymentsController

### Fetch Bookings with Quality Check
The main functionality of the application is in the BookingsQualityCheckService.rb. That fetches booking data from an external API through a service, processes the bookings, calculates the amount with fees, and performs the quality check on each booking. The results are then displayed on the with_quality_check view.

To use the application, visit http://localhost:3000/payments/with_quality_check in your web browser.
```
Just make it sure that your server side (server application) should running for running client side.
```
The page will display the bookings with their details, including the amount with fees, quality check results, overpayments, and underpayments.
