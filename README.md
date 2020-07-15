# Rasa Docker image for ARM 

[![Continous Integration](https://github.com/koenvervloesem/rasa-docker-arm/workflows/Tests/badge.svg)](https://github.com/koenvervloesem/rasa-docker-arm/actions)
[![GitHub license](https://img.shields.io/github/license/koenvervloesem/rasa-docker-arm.svg)](https://github.com/koenvervloesem/rasa-docker-arm/blob/master/LICENSE)

[Rasa](https://rasa.com) is an open source machine learning framework to automate text- and voice-based conversations. It doesn't have an official Docker image for ARM, so this project builds such an image (for the `linux/arm/v7` architecture) that you can run on a Raspberry Pi.

The resulting image stays as close as possible to Rasa's official Docker container. The only changes are added pre-built wheels for TensorFlow and TensorFlow Addons, some extra dependencies installed and the user ID changed to 1000 to align with the `pi` user on Raspberry Pi OS (Raspbian).

## System requirements

* Raspberry Pi (tested on Raspberry Pi 4B with 2 GB RAM)
* 16 GB microSD card
* [Raspberry Pi OS](https://www.raspberrypi.org/downloads/raspberry-pi-os/) (previously called Raspbian) Buster (10), 32-bit

If you manage to build the Docker image on another version of Raspbian, another Linux distribution, another model of the Raspberry Pi or even another ARM computer or cross-build it on another architecture, please let me know so I can generalize the script. 

## Usage

First make sure to have Docker installed:

```shell
curl -sSL https://get.docker.com | sh 
sudo usermod -aG docker pi  
```

After this, log out and log in again.

Then, if you want to build a Docker image of the latest Rasa version supported by this project (which is stored in the file [RASA_VERSION](RASA_VERSION)), just run:

```shell
make docker 
```

If you want to build an image for a specific Rasa version, run the build script with the version number as an argument:

```shell
./scripts/build_docker.sh 1.10.5
```

The build script downloads the version's archive, patches it and builds the Docker image.

If all goes well, at the end you should be able to run the Rasa Docker container on your Raspberry Pi, for instance with a [Docker Compose file](docker-compose.yml):

```shell
docker-compose up -d
```

After this, you can create a Rasa project with:

```shell
docker-compose run rasa init
```

## Patching other Rasa versions
If you want to build a Docker image for another Rasa version than the ones supported by this project, just copy the unpacked Rasa archive, make your changes, create the patch and put it in the directory [patches](patches) with the version number in the file name. Then the build script will pick this up. For instance:

```shell
wget -O rasa-1.10.5.tar.gz https://github.com/RasaHQ/rasa/archive/1.10.5.tar.gz
tar xzf rasa-1.10.5.tar.gz
cp -r rasa-1.10.5 rasa-1.10.5-2
# Make your changes in the `rasa-1.10.5-2` directory
diff -ruN rasa-1.10.5 rasa-1.10.5-2 > patches/rasa-1.10.5-arm.patch
./scripts/build_docker.sh 1.10.5
```

If you have successfully built the release, please contribute your patch to this project by a pull request so others can benefit from it too.

## Motivation 

Someone on the Rhasspy forum [failed to install Rasa on his Raspberry Pi 4](https://community.rhasspy.org/t/rasa-nlu-docker-installation-fails/1220), and I became curious. How difficult could it be? Well, quite difficult, as it turned out to be.

I had to build a wheel for [TensorFlow Addons on ARM](https://github.com/koenvervloesem/tensorflow-addons-on-arm), which was quite a challenge. To build this wheel, I needed to build [Bazel on ARM](https://github.com/koenvervloesem/bazel-on-arm/). After these slight detours, I finally managed to build a working Docker image for Rasa on ARM.

## Docker image on Docker Hub 

You don't have to build this Docker image yourself, you can find it on Docker Hub as [koenvervloesem/rasa](https://hub.docker.com/r/koenvervloesem/rasa). Download the latest version with:

```shell
docker pull koenvervloesem/rasa
```

If you want to download a specific version, use:

```shell
docker pull koenvervloesem/rasa:1.10.5
```

## References 

When I was searching for a way to run Rasa on a Raspberry Pi, I encountered the following projects, which I didn't use for various reasons but they gave some helpful background information:

* [Running RASA on the RPi 4 with Raspbian Buster!](https://forum.rasa.com/t/running-rasa-on-the-rpi-4-with-raspbian-buster/20805): An initiative by [Julian Gerhard](https://forum.rasa.com/u/juliangerhard) and [Jacob Zelki](https://forum.rasa.com/u/TheCedarPrince) without Docker and with Python 3.6.
* [Getting RASA to Work on the Raspberry Pi 4 (Buster)](https://github.com/RasaHQ/rasa/issues/4603): An issue in Rasa's GitHub repository concerning the same initiative.
* [rgstephens/rasaPi](https://github.com/rgstephens/rasaPi): An attempt by [Greg Stephens](https://github.com/rgstephens) to build a Rasa Docker image for ARM.

## License

This project is provided by [Koen Vervloesem](mailto:koen@vervloesem.eu) as open source software with the MIT license. See the [LICENSE](LICENSE) file for more information.
