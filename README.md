# DeliveryApp (IOS)
Delivery project which displays a list of delivery items with their respective location coordinates on Google Maps.

# Installation
To run the project :
- a) Navigate to root folder of the project. 
- b) Open the terminal and cd to the directory containing the Podfile.
- c) Delete the existing Podfile.lock, Pods, and Assignment.xcworkspace file if exists
- d) Run the "pod install" or "pod update"command
- e) Open xcworkspace and run the app 

# Requirement :
- MacOs: 10.14
- Xcode : 10.2

# Supported Version
- iOS :  (11.x, 12.x)

# Language 
- Swift 5.0

# Design Pattern
## MVC

- Model : Model stores the data from server and local databse. ItemModel is used for holding data of delivery items and LocationModel is used for holding data of location for the delivery items. Model is interacting with the data service layer.
    1. CoreDataService : This class interacts with database i.e CoreData. It performs the all database related operations and responds back to the view controller.
    2. DataService: This class interacts remotely. It retrieves the data from the server and returns back to view controller.
- View: The view layer is the face of your app. The view will only render the UI. View shows the data from model through viewController as view is model-independant.
- Controller: The controller mediates between the view and the model. Controller handles all the business related logic along with the view dependant logic.

# Version
- 1.0

# Data Caching
1. Core Data is used for storing/caching app data.
2. AlamofireImage is used for caching images.

# Generating key for Google Maps
1. Go to the Google Cloud Platform Console(https://console.cloud.google.com/flows/enableapi?apiid=maps_ios_backend&reusekey=true).
2. Create or select a project.
3. Click Continue to enable the Maps SDK for iOS.
4. On the Credentials page, get an API key. 
5. Click Save.
6. In the project, open Shared/Constants.swift file and assign the respective API key to the constant "apiKey".

# Assumptions        
1. The app is designed for iPhones and with portrait mode.      
2.  Supported mobile platforms are iOS (11.x, 12.x)        
3.  Device support - iPhone 5s, iPhone 6 Series, iPhone SE, iPhone 7 Series, iPhone 8 Series, iPhone X Series    
4.  iPhone app support would be limited to portrait mode.
5.  Data caching is available, but data syncing(checking duplicates) is not supported right now.
   - a) The app will fetch data from cache till the data is available
   - b) If offset data is not available in the cache, the app will fetch data from the server starting from that offset.
   - c) If any cached data is updated on the server then updating into local data is not considered.
   - d) If any cached data is deleted from the server then local cache data will not delete.
6. UI test cases are not considered and not implemented.

# "Firebase Crashlytics"
The Firebase Crashlytics is integrated into the project to collect the crash reports. The crash report will be available on the firebase console. 
To change the firebase account, follow the below steps:
1. Go to https://console.firebase.google.com/ and create an app
2. Enter the Projects bundle identifier i.e com.kunal.DeliveryApp
3. Fill the other relevant details and download the GoogleService-Info.plist file.
4. Now navigate to Resource folder to the app and replace the existing GoogleService-Info.plist file with your new GoogleService-Info.plist file.
5. Run the app
6. For more details about the Firebase Crashlytics integration, follow details on this link : https://firebase.google.com/docs/crashlytics/get-started

# "SwiftLint"
1. Install the SwiftLint is by downloading SwiftLint.pkg from latest GitHub release and running - https://github.com/realm/SwiftLint/releases
Or by HomeBrew by running "brew install swiftlint" command
2. Add the run script in the xcode (target -> Build pahse -> run script -> add the script) if not added
3. If need to change the rules of swiftlint, goto root folder of the project
4. Open the .swiftlint.yml file and modify the rules based on the requirement

# "Cocoa Pod Used"      
1. Alamofire
2. AlamofireImage
3. GoogleMaps
4. ObjectMapper
5. Firebase/Core
6. OHHTTPStubs/Swift
7. Fabric
8. Crashlytics

# Code Coverage
- Just need to run Test on Xcode ( cmd+U )
- Code coverage of CoreData class is less because NSBatchDeleteRequest is not supported for InMemory type persistence store coordinator.

## Unit Testing
- Unit testing is done by using XCTest.

# Application Screenshot
![Simulator Screen Shot - iPhone Xs - 2019-05-22 at 00 56 44](https://user-images.githubusercontent.com/28871881/58124744-7a94ea00-7bfe-11e9-9fd7-7d8c60728df2.png)

![Simulator Screen Shot - iPhone Xs - 2019-05-22 at 00 56 58](https://user-images.githubusercontent.com/28871881/58124805-9d270300-7bfe-11e9-8e0b-cd32d3592149.png)

![Simulator Screen Shot - iPhone Xs - 2019-05-22 at 00 57 03](https://user-images.githubusercontent.com/28871881/58124852-b334c380-7bfe-11e9-9fad-e8998f3ad48a.png)

# External Library
None

# TODO / IMPROVMENTS 
- UI Testing
- The coverage can be improved more.

# MIT License

## Copyright (c) 2019 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
