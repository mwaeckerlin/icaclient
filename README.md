# Citrix ICA-Client

Citrix icaclient is a terribly bad designed an terribly bad
implemented tool for remote desktop connections. It is a 32-bit
Firefox plugin, even on 64-bit Linux systems, so it corrupts your
operating system, or at least your Firefox installation. Even then, it
need fixes and most of the time, it does not work.  Still I have to
use it on work. So I want to run it in a well defined environment:
Encapsulate in a docker container.

## Build the container

### ICA-Client and License

I the `CITRIX LICENSE AGREEMENT` stored in file `LICENSE`, there is no
prohibition of distribution of the icaclient. So i suppose, I am
allowed to distribute it, als long as you follow the license
restrictions, i.e. you only use it for the Citrix products it is
intended to be used with. Therefore the icaclient is part of this
repository. So you must accept the `LICENSE` if you use this docker
container.

Otherwise, you could also  download the client from:

https://www.citrix.de/downloads/citrix-receiver/linux/receiver-for-linux-13-2.html

### Build Command

As usual:
        docker build --rm --force-rm -t mwaeckerlin/icaclient .

## Usage; Run the Client

Since it is an X11 GUI software, usage is in two steps:
  1. Run a background container as server (only required once).

        docker run -d --name icaclient mwaeckerlin/icaclient
  2. Connect to the server using `ssh -X` (as many times you want). 
     logging in with `ssh` automatically opens a firefox window

        ssh -X browser@$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' icaclient)
  3. Configure firefox (only the first time you created a container):
      1. Open about:addons in the URL bar
      2. Set ica-client to `allways activate`
  4. Browse to your ICA service, start the client and enjoy.

You can configure firefoy and set bookmarks. As long as you don't remove the container and you reuse the same container, al your changes persist. You could also tag and push your configuration to a registry to backup (should be your own private registry for your privacy).
