AiVA-96 for AVS SDK on Dragon Board 410c
---
The AiVA-96 for AVS provides far-field voice capture using the XMOS XVF3000 voice processor.

Combined with a Raspberry Pi running the Amazon Alexa Voice Service (AVS) Software Development Kit (SDK), this kit allows you to quickly prototype and evaluate talking with Alexa.

To find out more, visit: https://wizeiot.com home page   
and: https://developer.amazon.com/alexa-voice-service

This respository provides a simple-to-use automated script to install the Amazon AVS SDK on a Dragon Board 410c and configure the Dragon Board 410c to use the AiVA-96 for AVS for audio.

Prerequisites
---

You will need:

- AiVA-96 Board
- Dragon Board 410c
- Dragon Board 410c power supply
- MicroSD card (min. 16GB)
- Monitor with HDMI input
- HDMI cable
- Fast-Ethernet connection with internet connectivity  

You will also need an Amazon Developer account: https://developer.amazon.com


Hardware setup
---
Setup your hardware by following the Hardware Setup at: https://wizeiot.com home page

AVS SDK installation and Dragon Board 410c audio setup
---
Full instructions to install the AVS SDK on to a Dragon Board 410c and configure the audio to use the AiVA-96 are detailed in the Getting Started Guide available from: https://wizeiot.com home page.

Brief instructions and additional notes are below:

1. Install Debian (Stretch) on the Dragon Board 410c.  
   You shoud use [Debian 17.09](http://releases.linaro.org/96boards/dragonboard410c/linaro/debian/17.09/dragonboard410c_sdcard_install_debian-283.zip)

2. Open a terminal on the Dragon Board 410c and clone this repository
    ```
    cd ~; git clone https://github.com/roykang75/alexa-avs-sample-app-for-AiVA-dragonboard410c.git
    ```   
3. You'll need to register a device and create a security profile at developer.amazon.com. [Click here](https://github.com/alexa/alexa-avs-sample-app/wiki/Create-Security-Profile) for step-by-step instructions.

    IMPORTANT: The allowed origins under web settings should be http://localhost:3000 and https://localhost:3000. The return URLs under web settings should be http://localhost:3000/authresponse and https://localhost:3000/authresponse.

    If you already have a registered product that you can use for testing, feel free to skip ahead.

4. Run the installation script
    ```
    cd AiVA-96-google-assistant-setup/
    bash automated_install.sh
    ```


---


## Important considerations

* Review the AVS [Terms & Agreements](https://developer.amazon.com/public/solutions/alexa/alexa-voice-service/support/terms-and-agreements).  

* The earcons associated with the sample project are for **prototyping purposes only**. For implementation and design guidance for commercial products, please see [Designing for AVS](https://developer.amazon.com/public/solutions/alexa/alexa-voice-service/content/designing-for-the-alexa-voice-service) and [AVS UX Guidelines](https://developer.amazon.com/public/solutions/alexa/alexa-voice-service/content/alexa-voice-service-ux-design-guidelines).
