# agora_mobile

An androind app for the Agora Capstone project. Agora is a web and mobile application that 
provides real-time tracking of government legislation and legislators at the local and federal 
levels, consolidating key updates in one convenient location. Its goal is to keep users informed 
with comprehensive legislation summaries, personalized home feeds, and in-depth information about 
representatives.

Website: [](https://agoraforthepeople.net/)


## Getting Started

To use the app as is you can download the apk here: 
[Agora APK](https://drive.google.com/file/d/16zFuzTw1NEfqoKmUXI5pqXVMRPSgsxnl/view?usp=sharing)

## Setting Up Flutter

1. Launch VS Code
2. Add the Flutter extension to VS Code
    To add the Dart and Flutter extensions to VS Code, visit the Flutter extension's marketplace page, 
    then click Install. If prompted by your browser, allow it to open VS Code.
3. Install Flutter with VS Code
    1. Open the command palette in VS Code.
        Go to View > Command Palette or press Control + Shift + P.
    2. In the command palette, type flutter.
    3. Select Flutter: New Project.
    4. VS Code prompts you to locate the Flutter SDK on your computer. Select Download SDK.
    5. When the Select Folder for Flutter SDK dialog displays, choose where you want to install Flutter.
    6. Click Clone Flutter.
    7. Click Add SDK to PATH.

## Setting Up Andriod Studio

1. Install Android Studio
2. Install Android SDK and tools
    1. Launch Android Studio.
    2. Open the SDK Manager settings dialog.
        a. If the Welcome to Android Studio dialog is open, click the More Actions 
        button that follows the New Project and Open buttons, then click SDK Manager 
        from the dropdown menu.
        b. If you have a project open, go to Tools > SDK Manager.
    3. If the SDK Platforms tab is not open, switch to it.
    4. Verify that the first entry with an API Level of 36 has been selected.
        If the Status column displays Update available or Not installed:
            a. Select the checkbox for that entry or row.
            b. Click Apply.
            c. When the Confirm Change dialog displays, click OK.
            d. The SDK Component Installer dialog displays with a progress indicator.
            e. When the installation finishes, click Finish.
    5. Switch to the SDK Tools tab.
    6. Verify that the following SDK Tools have been selected:
        - Android SDK Build-Tools
        - Android SDK Command-line Tools
        - Android Emulator
        - Android SDK Platform-Tools
    7. If the Status column for any of the preceding tools displays Update available or Not installed:
        a. Select the checkbox for the necessary tools.
        b. Click Apply.
        c. When the Confirm Change dialog displays, click OK.
        d. When the installation finishes, click Finish.
4. Agree to the Android licenses
    1. Open your preferred terminal.
    2. Run the following command to review and sign the SDK licenses. 
        $ flutter doctor --android-licenses
    3. Read and accept any necessary licenses.

## Set Up Android Emulator

1. Set up your development device
2. Set up a new emulator
    1. Start Android Studio.
    2. Open the Device Manager settings dialog.
    3. Click the Create Virtual Device button that appears as a + icon.
    4. Select either Phone under Form Factor.
    5. Select a device definition. You can browse or search for the device.
    6. Click Next.
    7. If the option is provided, select either x86 Images or ARM Images depending on if 
        your development computer is an x64 or Arm64 device.
    8. Select one system image for the Android version you want to emulate.
        a. If the desired image has a Download icon to the left of the system image name, click it.
        b. When the download completes, click Finish.
    9. Click Additional settings in the top tab bar and scroll to Emulated Performance.
    10. From the Graphics acceleration dropdown menu, select an option that mentions Hardware.
    11. Verify your virtual device configuration. If it is correct, click Finish.
3. Try running the emulator
    In the Device Manager dialog, click the Run icon to the right of your desired virtual device.
    The emulator should start up and display the default canvas for your 
    selected Android OS version and device.

## Running the project

Open the project file and click run and debug. Ensure that you turn off uncaught exceptions in the 
debugger. This is becuase the debugger believes that there are uncaught errors but they are 
actually caught. 

