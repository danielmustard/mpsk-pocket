FROM debian:bookworm

# Install prerequisites
RUN apt-get update && apt-get install -y curl gnupg

# Create directory and set permissions
RUN install -d -o root -g root -m 0755 /etc/apt/keyrings

# Add the Network RADIUS GPG key
RUN curl -s 'https://packages.networkradius.com/pgp/packages%40networkradius.com' | \
    tee /etc/apt/keyrings/packages.networkradius.com.asc > /dev/null

# Add APT preferences file to prioritize Network RADIUS repository
RUN printf 'Package: /freeradius/\nPin: origin "packages.networkradius.com"\nPin-Priority: 999\n' | \
    tee /etc/apt/preferences.d/networkradius > /dev/null

# Add Network RADIUS APT sources
RUN echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.networkradius.com.asc] http://packages.networkradius.com/freeradius-4.0/debian/bookworm bookworm main" | \
    tee /etc/apt/sources.list.d/networkradius.list > /dev/null && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.networkradius.com.asc] http://packages.networkradius.com/extras/debian/bookworm bookworm main" | \
    tee -a /etc/apt/sources.list.d/networkradius.list > /dev/null



# Install FreeRADIUS and the REST module
RUN apt-get update && \
    apt-get install -y freeradius freeradius-rest && \
    apt-get install curl && \
    rm -rf /var/lib/apt/lists/*

# Clean up APT cache to reduce image size
RUN rm -rf /var/lib/apt/lists/*

# Copy and set permissions on the modules
#COPY ./mods-available /etc/freeradius/mods-available/

##COPY ./mods-config /etc/freeradius/mods-config
#
#COPY ./mods-enabled /etc/freeradius/mods-enabled/
#
#COPY ./policy.d /etc/freeradius/policy.d/
#
#COPY ./sites-available /etc/freeradius/sites-available/
#
##COPY ./sites-available/default /etc/freeradius/sites-available/default


## Copy Clients.conf

COPY ./FreeRADIUS-Config/etc/freeradius/clients.conf /etc/freeradius/clients.conf

# Set the correct permissions on all relevant files and folders
RUN chmod 644 /etc/freeradius/* \
    && chmod -R o-w /etc/freeradius/* \
    && chmod -R o-w /etc/freeradius/clients.conf \
    && chown -R root:freerad /etc/freeradius/*

# Enable the REST module by linking
#RUN ln -s /etc/freeradius/mods-available/rest /etc/freeradius/mods-enabled/rest

# Final step: confirm no global write permissions on the link
#RUN chmod 644 /etc/freeradius/mods-enabled/rest


# Expose RADIUS ports
EXPOSE 1812/udp 1813/udp 443

# Start FreeRADIUS in the foreground
#CMD ["freeradius", "-f", "-l", "stdout"]
CMD ["freeradius", "-X"]