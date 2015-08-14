# Start with:
# docker run -d --restart=always --name icaclient icaclient
# ssh -X browser@$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' icaclient)
# then open about:addons in firefox and set ica-client to "allways activate"
FROM ubuntu:latest
MAINTAINER Marc Wäckerlin

WORKDIR /tmp/install
ADD icaclient_*.deb icaclient.deb
RUN dpkg --add-architecture i386
RUN apt-get -y update
RUN apt-get -y install firefox openssh-server
RUN dpkg -i icaclient.deb || apt-get -y -f install
RUN ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/
RUN c_rehash /opt/Citrix/ICAClient/keystore/cacerts/
RUN rm -f /usr/lib/mozilla/plugins/npwrapper.npica.so \
          /usr/lib/firefox/plugins/npwrapper.npica.so \
          /usr/lib/mozilla/plugins/npica.so
RUN ln -s /opt/Citrix/ICAClient/npica.so /usr/lib/firefox-addons/plugins/npica.so

RUN mkdir /var/run/sshd
RUN sed -i 's,^ *PermitEmptyPasswords .*,PermitEmptyPasswords yes,' /etc/ssh/sshd_config
RUN sed -i '1iauth sufficient pam_permit.so' /etc/pam.d/sshd

RUN useradd -ms /home/browser/browser.sh browser
USER browser
WORKDIR /home/browser

RUN echo "#!/bin/bash" > browser.sh
RUN echo "firefox --new-instance \$*" >> browser.sh
RUN chmod +x browser.sh

RUN mkdir .ICAClient
RUN echo ";********************************************************************" >> .ICAClient/wfclient.ini
RUN echo ";" >> .ICAClient/wfclient.ini
RUN echo ";    wfclient.ini" >> .ICAClient/wfclient.ini
RUN echo ";" >> .ICAClient/wfclient.ini
RUN echo ";    User configuration for Citrix Receiver for Unix" >> .ICAClient/wfclient.ini
RUN echo ";" >> .ICAClient/wfclient.ini
RUN echo ";    Copyright 1994-2006, 2009 Citrix Systems, Inc. All rights reserved." >> .ICAClient/wfclient.ini
RUN echo ";" >> .ICAClient/wfclient.ini
RUN echo ";********************************************************************" >> .ICAClient/wfclient.ini
RUN echo "" >> .ICAClient/wfclient.ini
RUN echo "[WFClient]" >> .ICAClient/wfclient.ini
RUN echo "Version = 2" >> .ICAClient/wfclient.ini
RUN echo "" >> .ICAClient/wfclient.ini
RUN echo "KeyboardLayout = (User Profile)" >> .ICAClient/wfclient.ini
RUN echo "KeyboardMappingFile = automatic.kbd" >> .ICAClient/wfclient.ini
RUN echo "KeyboardDescription = Automatic (User Profile)" >> .ICAClient/wfclient.ini
RUN echo "KeyboardType=(Default)" >> .ICAClient/wfclient.ini
RUN echo "" >> .ICAClient/wfclient.ini
RUN echo "CREnabled=True" >> .ICAClient/wfclient.ini
RUN echo "BrowserProtocol=HTTPonTCP" >> .ICAClient/wfclient.ini
RUN echo "BrowserTimeout=5000" >> .ICAClient/wfclient.ini
RUN echo "CDMAllowed=On" >> .ICAClient/wfclient.ini
RUN echo "" >> .ICAClient/wfclient.ini
RUN echo "ClientPrinterQueue=On" >> .ICAClient/wfclient.ini
RUN echo "" >> .ICAClient/wfclient.ini
RUN echo "ClientManagement=On" >> .ICAClient/wfclient.ini
RUN echo "ClientComm=On" >> .ICAClient/wfclient.ini
RUN echo "MouseSendsControlV=True" >> .ICAClient/wfclient.ini
RUN echo "MouseDoubleClickTimer=" >> .ICAClient/wfclient.ini
RUN echo "MouseDoubleClickWidth=" >> .ICAClient/wfclient.ini
RUN echo "MouseDoubleClickHeight=" >> .ICAClient/wfclient.ini
RUN echo "" >> .ICAClient/wfclient.ini
RUN echo "Hotkey12Shift=Ctrl+Shift" >> .ICAClient/wfclient.ini
RUN echo "Hotkey11Shift=Ctrl+Shift" >> .ICAClient/wfclient.ini
RUN echo "Hotkey10Shift=Ctrl+Shift" >> .ICAClient/wfclient.ini
RUN echo "Hotkey9Shift=Ctrl+Shift" >> .ICAClient/wfclient.ini
RUN echo "Hotkey8Shift=Ctrl+Shift" >> .ICAClient/wfclient.ini
RUN echo "Hotkey7Shift=Ctrl+Shift" >> .ICAClient/wfclient.ini
RUN echo "Hotkey6Shift=Ctrl+Shift" >> .ICAClient/wfclient.ini
RUN echo "Hotkey5Shift=Ctrl+Shift" >> .ICAClient/wfclient.ini
RUN echo "Hotkey4Shift=Ctrl+Shift" >> .ICAClient/wfclient.ini
RUN echo "Hotkey3Shift=Ctrl+Shift" >> .ICAClient/wfclient.ini
RUN echo "Hotkey2Shift=Ctrl+Shift" >> .ICAClient/wfclient.ini
RUN echo "Hotkey1Shift=Ctrl+Shift" >> .ICAClient/wfclient.ini
RUN echo "" >> .ICAClient/wfclient.ini
RUN echo "IgnoreErrors=9,15" >> .ICAClient/wfclient.ini
RUN echo "" >> .ICAClient/wfclient.ini
RUN echo "[Thinwire3.0]" >> .ICAClient/wfclient.ini
RUN echo "DesiredHRES = 640" >> .ICAClient/wfclient.ini
RUN echo "DesiredVRES = 480" >> .ICAClient/wfclient.ini
RUN echo "DesiredColor = 15 " >> .ICAClient/wfclient.ini
RUN echo "PersistentCachePath = $HOME/.ICAClient/cache" >> .ICAClient/wfclient.ini
RUN echo "PersistentCacheMinBitmap = 2048" >> .ICAClient/wfclient.ini
RUN echo "PersistentCacheEnabled = Off" >> .ICAClient/wfclient.ini
RUN echo "ApproximateColors=No" >> .ICAClient/wfclient.ini
RUN echo "" >> .ICAClient/wfclient.ini
RUN echo "ProxyFallback=yes" >> .ICAClient/wfclient.ini

USER root
CMD /usr/sbin/sshd -D
