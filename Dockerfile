from docker:git

WORKDIR /src

COPY ./script.sh ./script.sh
COPY ./GITHUB_TOKEN ./GITHUB_TOKEN
COPY ./HUB_USERNAME ./HUB_USERNAME
COPY ./HUB_PASS ./HUB_PASS

RUN chmod 755 ./script.sh

ENTRYPOINT ["sh","./script.sh"]

