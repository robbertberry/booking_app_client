## Setup Guide

Follow this steps to run this project locally
### Ruby version
2.7.2

### Rails version
5.2.8

Add this ENV variable to credentials.yml.enc or some other ENV file to run this app

```
open_exchange_rates:
  app_id: 18df36775b104a8593d81efac1935fa0
```

Then just have to run these two statements

```
bundle install
```

```
rails s
```

The Payments Application has a controller called PaymentsController, which provides the following features:

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
The main functionality of the application is in the with_quality_check action of the PaymentsController. This action fetches booking data from an external API, processes the bookings, calculates the amount with fees, and performs the quality check on each booking. The results are then displayed on the with_quality_check view.

To use the application, visit http://localhost:3000/payments/with_quality_check in your web browser. 
```
Just make it sure that your server side (server application) should running for running client side.
```
The page will display the bookings with their details, including the amount with fees, quality check results, overpayments, and underpayments.