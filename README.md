## This repository is AVS for AiVA + DragonBoard 410c

## What is AVS?

[Alexa Voice Service](https://developer.amazon.com/avs) (AVS) is Amazon’s intelligent voice recognition and natural language understanding service that allows you as a developer to voice-enable any connected device that has a microphone and speaker.

---

## Required hardware
Before you get started, let's review what you'll need:

AiVA Board
Arrow DragonBoard410c

## Required software

Debian Linux for DragonBoard41c

## Get started

## Register a product

Before we get started, you'll need to register a device and create a security profile at developer.amazon.com. [Click here](https://github.com/alexa/alexa-avs-sample-app/wiki/Create-Security-Profile) for step-by-step instructions.

IMPORTANT: The allowed origins under web settings should be http://localhost:3000 and https://localhost:3000. The return URLs under web settings should be http://localhost:3000/authresponse and https://localhost:3000/authresponse.

If you already have a registered product that you can use for testing, feel free to skip ahead.

## Setup and run

```
sudo apt-get update
sudo apt-get upgrade
git clone https://github.com/roykang75/alexa-avs-sample-app-for-AiVA-dragonboard410c.git
chmod +x automated_install.sh
./automated_install.sh
```

---


## Important considerations

* Review the AVS [Terms & Agreements](https://developer.amazon.com/public/solutions/alexa/alexa-voice-service/support/terms-and-agreements).  

* The earcons associated with the sample project are for **prototyping purposes only**. For implementation and design guidance for commercial products, please see [Designing for AVS](https://developer.amazon.com/public/solutions/alexa/alexa-voice-service/content/designing-for-the-alexa-voice-service) and [AVS UX Guidelines](https://developer.amazon.com/public/solutions/alexa/alexa-voice-service/content/alexa-voice-service-ux-design-guidelines).

* **Usage of Sensory & KITT.AI wake word engines**: The wake word engines included with this project (Sensory and KITT.AI) are intended to be used for **prototyping purposes only**. If you are building a commercial product with either solution, please use the contact information below to enquire about commercial licensing -
  * [Contact Sensory](http://www.sensory.com/support/contact/us-sales/) for information on TrulyHandsFree licensing.
  * [Contact KITT.AI](mailto:snowboy@kitt.ai) for information on SnowBoy licensing.

* **IMPORTANT**: The Sensory wake word engine included with this project is time-limited: code linked against it will stop working when the library expires. The library included in this repository will, at all times, have an expiration date that is at least **120 days** in the future. See Sensory's [GitHub](https://github.com/Sensory/alexa-rpi#license) page for more information on how to renew the license for non-commercial use.

---

## Contribute

* Want to report a bug or request an update to the documentation? See [CONTRIBUTING.md](https://github.com/alexa/alexa-avs-sample-app/blob/master/CONTRIBUTING.md).
* Having trouble? Check out our [troubleshooting guide](../../wiki/Troubleshooting).
* Have questions or need help building the sample app? Open a [new issue](https://github.com/alexa/alexa-avs-sample-app/issues/new).
