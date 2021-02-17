# Crypto.com Pay Sample App (iOS SwiftUI)

## System Flow

1. When customer checks out his order in merchant app, merchant server calls Crypto.com Pay server to create a payment, a `return_url` is provided by merchant (explains below). The payment object returned will consist of a `payment_url`.
2. Merchant app open webview and navigate to `payment_url`, the payment page is displayed.
3. Payment page has deep link for the customer to switch to Crypto.com app.
4. Customer completes payment in Crypto.com’s app.
5. Customer switches back to merchant app.
6. Merchant app’s webview will be redirected to `return_url` once payment is captured, merchant app detects the redirection, close the webview.
7. Merchant app calls merchant server to complete the order.
8. Merchant server calls Crypto.com Pay server again to confirm the payment is indeed captured.
9. Merchant server completes the order.

## How to Use

1. Sign up for a Crypto.com Pay account, if you don't already have one.
2. Once you have access to the Crypto.com Pay Merchant Dashboard, You will be able to generate a secret key.
3. Run this App.
4. Tap settings icon at the top right hand corner.
5. Fill in the secret key in the Settings view.
6. Test the Payment Flow in the App.

## Support

* Visit our [Merchant FAQ](https://help.crypto.com/en/collections/1512001-crypto-com-pay-merchant-faq) and [API Documentation](https://pay-docs.crypto.com/).
* Open an issue if you are having troubles with this sample code.