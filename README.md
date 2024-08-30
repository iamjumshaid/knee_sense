
# KneeSense - Rehabilitation for Knee Injuries

KneeSense is an innovative rehabilitation tool designed to assist in the recovery from knee injuries. The project integrates a sensorized knee orthosis with a cross-platform mobile application, allowing for real-time monitoring of knee movement and temperature during exercise. The solution emphasizes affordability, user engagement, and the ability to bridge the gap between doctors and patients through remote monitoring and personalized exercise regimens.

## Project Description

KneeSense combines hardware and software to create a comprehensive rehabilitation solution for knee injuries. The hardware consists of a smart knee orthosis embedded with Inertial Measurement Units (IMUs) and temperature sensors. These sensors provide critical data on knee movement and temperature changes during rehabilitation exercises. The data is transmitted to a mobile application built using Flutter, which presents the information in a user-friendly interface for both patients and doctors.

### Key Features
- **Real-time Monitoring**: Track knee movement and temperature in real-time using integrated sensors.
- **Remote Doctor-Patient Communication**: Allows doctors to monitor patients' progress remotely and update exercise regimens as needed.
- **Customizable Exercises**: Doctors can assign and customize exercises tailored to each patient’s rehabilitation needs.
- **User-Friendly Interface**: The mobile application is designed to be intuitive and accessible, ensuring ease of use for patients of all ages.

## Functionalities

1. **Knee Angle Measurement**: Utilizes IMUs to accurately measure the angle of the knee during exercises, helping track rehabilitation progress.
2. **Temperature Monitoring**: Employs temperature sensors to monitor knee temperature fluctuations, which can indicate inflammation or other issues.
3. **Exercise Management**: The mobile app provides a platform for patients to view and perform exercises prescribed by their doctors. It also allows doctors to monitor the patient’s progress and adjust the treatment plan accordingly.
4. **Data Storage and Retrieval**: Patient data, including exercise performance and sensor readings, is stored in Firebase, enabling both real-time monitoring and historical data review.

## Hardware Overview

The hardware setup includes:
- **IMUs (BNO086)**: These sensors are used to measure knee angles by tracking the rotation of the thigh and shank.
- **Temperature Sensors (DS18B20)**: These sensors monitor the knee's temperature during exercises.
- **Microcontroller (ESP32-C3)**: The central unit that processes data from the sensors and communicates with the mobile app via Wi-Fi.
- **Power Supply**: The system is powered by a rechargeable battery, ensuring portability and ease of use.

For detailed information on the hardware setup, refer to the `hardware/` directory which contains all necessary microcontroller code.

## How to Run the Flutter App

### Prerequisites
- **Flutter SDK**: Ensure Flutter is installed and configured on your machine.
- **Dart SDK**: Dart is required as the programming language for Flutter.
- **Firebase Configuration**: Ensure you have set up Firebase for the project with appropriate configurations for authentication and real-time database usage.

### Steps to Run
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/knee_sense.git
   cd knee_sense
2. **Install Dependencies**:
   ```bash
	   flutter pub get
3. ****Configure Firebase****
4. ****Run the Flutter App****
	```bash
	   flutter run

## Demo Video
For a demonstration of the project in action, please refer to the `project-demo.mp4` file included in this repository.

## Contributors
-   Burhan Ali
-   Jumshaid Khan
-   Momina Atif Dar
-   Muhammad Osama Asghar



