FROM evgbay/cryptopro-csp-base:1.1.0

ARG LICENSE
ARG CA_ROOT_CERT
ARG CONTAINER_NAME=Admin
ARG CLIENT_PFX_FILE
ARG CLIENT_PFX_PASSWORD
ARG CLIENT_CERT_THUMB

RUN if [ -n "${LICENSE}" ]; then \
    /opt/cprocsp/sbin/amd64/cpconfig -license -set ${LICENSE}; \
    fi
RUN /opt/cprocsp/sbin/amd64/cpconfig -license -view

COPY config/certificates/${CA_ROOT_CERT} /tls/certs/
RUN /opt/cprocsp/bin/amd64/certmgr -inst -silent -store mROOT -file /tls/certs/${CA_ROOT_CERT}

COPY config/certificates/${CLIENT_PFX_FILE} /var/opt/cprocsp/keys/root/
WORKDIR /var/opt/cprocsp/keys/root/
RUN /opt/cprocsp/bin/amd64/certmgr -inst -provtype 24 -pfx -pin ${CLIENT_PFX_PASSWORD} -newpin=${CLIENT_PFX_PASSWORD} -cont "\\.\\HDIMAGE\\${CONTAINER_NAME}" -file ${CLIENT_PFX_FILE}

RUN mkdir -p /tls/stunnel/ && \
    /opt/cprocsp/bin/amd64/certmgr -export -cert -thumbprint ${CLIENT_CERT_THUMB} -dest /tls/stunnel/tls_client.cer && \
    /opt/cprocsp/bin/amd64/certmgr -list

COPY config/stunnel.conf /tls/stunnel/

CMD ["/opt/cprocsp/sbin/amd64/stunnel_thread", "/tls/stunnel/stunnel.conf"]