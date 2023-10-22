# Flutter Stripe Payment Integration

This Flutter project demonstrates how to integrate Stripe for payment processing. It covers setting up your Flutter app to work with Stripe, creating a payment intent, and implementing a payment sheet for a smooth payment experience.

## Getting Started

Before you start, make sure you have the following prerequisites in place:

1. Flutter SDK installed.
2. A Stripe account. If you don't have one, create an account at [stripe.com](https://stripe.com).

## First Step

1. Add the required dependencies to your `pubspec.yaml`:

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      flutter_stripe: <latest_version>
      http: ^0.13.3
    ```

2. Ensure that `ext_kotlin_version` is greater than or equal to `1.5.0` in your Android project.

3. Set the minimum SDK version to 21 in your `build.gradle` file.

4. Set the minimum iOS version to 11 in your Xcode project.

5. In `android/app/src/main/kotlin/MainAcitivity.kt`, add the following code:

    ```kotlin
    import io.flutter.embedding.android.FlutterFragmentActivity

    class MainActivity: FlutterFragmentActivity() {}
    ```

6. In your `AndroidManifest.xml`, set the application theme to use AppCompat:

    ```xml
    android:theme="@style/Theme.AppCompat"
    ```

7. Replace your `styles.xml` with the following:

    ```xml
    <?xml version="1.0" encoding="utf-8"?>
    <resources>
        <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is off -->
        <style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
            <!-- Show a splash screen on the activity. Automatically removed when
                Flutter draws its first frame -->
            <item name="android:windowBackground">@drawable/launch_background</item>
        </style>
        <!-- Theme applied to the Android Window as soon as the process has started.
            This theme determines the color of the Android Window while your
            Flutter UI initializes, as well as behind your Flutter UI while it's running.
            
            This Theme is only used starting with V2 of Flutter's Android embedding. -->
        <style name="NormalTheme" parent="Theme.MaterialComponents">
            <item name="android:windowBackground">?android:colorBackground</item>
        </style>
    </resources>
    ```

## Second Step

1. Go to [stripe.com](https://stripe.com) and create an account.

2. Once you have an account, go to the "Developers" tab.

3. Copy your Stripe **Publishable Key** and **Secret Key**.

## Third Step

Update your `main.dart` file with the following code:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "YOUR_PUBLISHABLE_KEY";
  runApp(const MyApp());
}
```

Replace `"YOUR_PUBLISHABLE_KEY"` with the Publishable Key you obtained from Stripe.

## Fourth Step

Now, let's set up the payment functionality. In your Flutter app, you can make payments using Stripe with the following code:

```dart
Map<String, dynamic>? paymentIntent;

Future<void> makePayment() async {
  try {
    paymentIntent = await createPaymentIntent("200", "USD");
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],
        style: ThemeMode.dark,
        merchantDisplayName: "Your Merchant Name",
      ));
    displayPayment();
  } catch (E) {
    debugPrint(E.toString());
  }
}

Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
  try {
    Map<String, dynamic> body = {
      "amount": calculatePayment(amount),
      "currency": currency,
      "payment_method_types[]": "card"
    };
    var response = await http.post(
      Uri.parse("https://api.stripe.com/v1/payment_intents"),
      body: body,
      headers: {
        "Authorization": "Bearer YOUR_SECRET_KEY",
        "Content-Type": "application/x-www-form-urlencoded"
      });
    return jsonDecode(response.body.toString());
  } catch (E) {
    debugPrint(E.toString());
  }
}

String calculatePayment(String amount) {
  final price = int.parse(amount) * 280;
  return price.toString();
}

Future<void> displayPayment() async {
  try {
    await Stripe.instance.presentPaymentSheet(
      options: const PaymentSheetPresentOptions(timeout: 3));
    // Handle payment success and UI updates here.
  } catch (e) {
    debugPrint(e.toString());
  }
}
```

Replace `"YOUR_SECRET_KEY"` with the Secret Key you obtained from Stripe, and customize the payment handling logic to suit your app's needs.

With these steps, your Flutter app is now set up for payment processing with Stripe. Enjoy seamless and secure payments!
