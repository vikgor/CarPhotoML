#  CarPhotoML

Simple app build with CoreML to detect a quality of a car photo.

Task:
User must take a photo of a car. 
Photo is considered "good" when the car is seen from the front side, with the license plate visible.
Photo is considered "bad" if the license plate is not visible, when the picture is taken from any side other than front and if the picture is not of a car.

The model was trained with CreateML on 300 photos and is accurate in 75% of test cases. In other 25% only 5% is when a bad photo goes through the check instead of getting marked as bad.
