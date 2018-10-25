FROM crystallang/crystal:latest
RUN apt-get update && \
    apt-get install -y build-essential curl libevent-dev libssl-dev libxml2-dev libyaml-dev libgmp-dev git tmux golang-go && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Node dependency
RUN curl --silent --location https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g yarn

# Go dependency and overmind process manager
RUN mkdir -p /usr/local/go
ENV GOPATH="/usr/local/go"
ENV PATH="/usr/local/go/bin:${PATH}"
RUN go get -u -f github.com/DarthSim/overmind

# Lucky cli
RUN git clone https://github.com/luckyframework/lucky_cli /usr/local/lucky_cli
WORKDIR "/usr/local/lucky_cli"
RUN git checkout v0.11.0
RUN shards install
RUN crystal build src/lucky.cr --release --no-debug
RUN mv lucky /usr/local/bin

WORKDIR /
