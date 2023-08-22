# Metal detector

A new Flutter project.
This [Metal detector] mobile application is meant to work as a metal detector, depending on some basics of flutter.

We needed through the programing process to use some sensors of the device, and We were aware of keeping the average user in mind so we did some calculations to preview understandable details.

Technically, we made use of [Magnetometer] sensor and got its dimension into array [x,y,z], then we calculated the magnitude of the three dimensions and saved the value, which we will compare it with some reference values.
And with some researches we knew that the reverence magnitude of the magnetic field would be almost 45~48, so we depended on the lower value due to the bad-quality sensors we had in mobile devices, so we could get values as accurate as possible.

Then we coded our app using (Flutter) and created a percentage Range to preview the ambit of metal existence nearby.

At last, we printed the magnetic array and a sign below to explain more details.


![WhatsApp Image 2022-12-24 at 08 22 55](https://github.com/amrgodovich/Metal-detector-app/assets/113524665/d5b3633d-dbaf-4275-92f9-12cc9511c444)


## Testing


https://youtube.com/shorts/aX7plgj4xEI?feature=share
