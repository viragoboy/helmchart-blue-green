FROM nginx:1.15.8-alpine

## Remove default Nginx website
RUN rm -rf /usr/share/nginx/html/*

# support running as arbitrary user which belogs to the root group
RUN chmod a+rwx /var/cache/nginx /var/run /var/log/nginx
# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8080;/' /etc/nginx/conf.d/default.conf
EXPOSE 8080
# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

# Create new user/group 'app', change file ownership, then switch to that user.
RUN addgroup app && adduser --system --ingroup app app
RUN chown -R app:app /usr/share/nginx/*
USER app

CMD ["nginx", "-g", "daemon off;"]
