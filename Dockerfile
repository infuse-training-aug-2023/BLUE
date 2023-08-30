FROM ruby as build

RUN apt-get update -y && \
    apt-get install -y wget unzip && \
    apt-get install -y curl gnupg && \
    apt-get install -y libnss3

ENV CHROMEDRIVER_VERSION=116.0.5845.110

RUN mkdir -p /dependencies

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable

RUN wget -q "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$CHROMEDRIVER_VERSION/linux64/chromedriver-linux64.zip" -O /dependencies/chromedriver.zip && \
    unzip /dependencies/chromedriver.zip -d /dependencies/chromedriver && \
    mv /dependencies/chromedriver/chromedriver-linux64/* /dependencies/chromedriver && \
    rm -r /dependencies/chromedriver/chromedriver-linux64 && \
    rm /dependencies/chromedriver.zip

RUN chmod +x /dependencies/chromedriver/chromedriver

ENV CHROMEDRIVER=/dependencies/chromedriver/chromedriver

WORKDIR /app

COPY . /app

RUN bundle i

FROM build as test
CMD ["ruby", "test.rb"]


FROM build as prod
CMD ["ruby", "main.rb"]