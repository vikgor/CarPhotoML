#  CarPhotoML

Simple app build with CoreML to detect a quality of a car photo.

### Stack:
Swift, CoreML, SnapKit, UDF

### Task:
When registering as a driver, user must take a photo of a car. 

Photo is considered "good" when the car is seen from the front side, with the license plate visible.
Photo is considered "bad" if the license plate is not visible, when the picture is taken from any side other than front and if the picture is not of a car.

| ![photoGood](https://github.com/vikgor/CarPhotoML/blob/develop/CarPhotoML/Resources/Assets.xcassets/carPhotoGood.imageset/carPhotoGood.jpeg)  |  ![photoBad 2](https://github.com/vikgor/CarPhotoML/blob/develop/CarPhotoML/Resources/Assets.xcassets/carPhotoBad.imageset/carPhotoBad.jpg)  |
|:-:|:-:|
| ✅ | ❌ |

Created with 300 photos, the ML model is only 17 Kb, and depending on the number of photos used to train the model to make it more accurate the model will be slightly larger in size, however no significant app size increase is expected.

The model is accurate in 75% of test cases. In other 25% only 5% is when a bad photo goes through the check instead of getting marked as bad. 
That means that only 5% of 'bad' photos will slip and  reach human verification where will be marked as bad by a support agent instead of current 100%.

The accuracy can be increased with further training.

### App screenshots (not up to date since the design was improved)

| ![screenshot 1](https://github.com/vikgor/CarPhotoML/blob/master/screenshots/1.png)  |  ![screenshot 2](https://github.com/vikgor/CarPhotoML/blob/master/screenshots/2.png)  |  ![screenshot 3](https://github.com/vikgor/CarPhotoML/blob/master/screenshots/3.png)  |
|:-:|:-:|:-:|

[More stats in this Google Sheet](https://docs.google.com/spreadsheets/d/1rR2GnTrdWJ1pjcHQFSWDqkakd1KBeJ2Ozcv4nOtsiiw/edit?usp=sharing)
