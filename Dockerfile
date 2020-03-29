FROM fedora:31

ENV GODOT_VERSION 3.2

ENV HOME /home/builder
ENV GODOT_TEMPLATE_DIR ${GODOT_VERSION}.stable
ENV GODOT_TEMPLATE_PATH $HOME/.local/share/godot/templates/
ENV GODOT /usr/local/bin/godot-headless

RUN adduser builder

RUN dnf install -y zip unzip git make

# Download and install Godot.
RUN curl -L https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip | funzip > ${GODOT} && chmod 755 ${GODOT}

# Download and install Butler.
RUN mkdir -p /opt/butler && \
      cd /opt/butler && \
      curl -L -sS https://broth.itch.ovh/butler/linux-amd64/LATEST/archive/default -o latest.zip && \
      unzip latest.zip && \
      chmod +x butler && \
      rm latest.zip


USER builder

# Download and install Godot export templates.
RUN mkdir -p ${GODOT_TEMPLATE_PATH} && \
      cd ${GODOT_TEMPLATE_PATH} && \
      curl -sS https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz -o godot-templates.zip && \
      unzip godot-templates.zip && \
      mv ./templates ./${GODOT_TEMPLATE_DIR} && \
      rm godot-templates.zip
