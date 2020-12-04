FROM khanlab/autotop_deps:latest

MAINTAINER jordandekraker@gmail.com

#copy contents of repo
COPY . /src/

ENV AUTOTOP_DIR /src

ENTRYPOINT ["/src/mcr_v97/run_singleSubject.sh", "/opt/mcr/v97" ]
