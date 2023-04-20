FROM httpd

# Install necessary programs
RUN apt update && apt install --yes \
  vim wget \
  && sed -i \
      -e 's/^#\(LoadModule .*mod_proxy.so\)/\1/' \
      -e 's/^#\(LoadModule .*mod_proxy_fcgi.so\)/\1/' \
      -e 's/^#\(LoadModule .*mod_rewrite.so\)/\1/' \
      conf/httpd.conf

COPY 000-default.conf conf/extra/

RUN echo 'IncludeOptional conf/extra/000-default.conf' >> conf/httpd.conf