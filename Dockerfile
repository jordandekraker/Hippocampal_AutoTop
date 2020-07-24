FROM khanlab/autotop_deps:latest

MAINTAINER jordandekraker@gmail.com

#copy contents of repo
COPY . /src/

# download reference atlases
RUN curl -s -L --retry 6  https://www.dropbox.com/s/40xtlok0ns4bo7j/atlases_CITI.tar | tar x -C /src && \
curl -s -L --retry 6  https://www.dropbox.com/s/g3jjqbrx62m9roo/atlases_UPenn_ExVivo.tar | tar x -C /src && \
chmod a+rX -R /src

ENV AUTOTOP_DIR /src

ENTRYPOINT ["/src/mcr_v97/run_singleSubject.sh", "/opt/mcr/v97" ]
