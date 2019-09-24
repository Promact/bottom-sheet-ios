Steps to implement Bottom sheet in your project :

MaryPopin is an extension of UIViewController so you just need to copy past 2 files of objective-c in your project. If you are using an Objective-C project then you just need to use directly. If you are using swift project then you need to create a Bridging header to use.

Create a view controller with the design of popups in the storyboard like below.
 



Now create two different ViewControllers.swift files to accommodate the coding of these two popups. Also, I have created a base class for the bottom sheet with some common functionality. The common things like pan gesture and some common controls are declared in the base class.
To give same sliding functionality like instagram I have given the Pan gesture like given below.


For detail explanation and understanding please download and check the code. The final result is like,
http://wiki.promact.com/link/101#bkmrk--2
  
