FROM caddy:2.10.2 AS caddy

# upgrade: github lightpanda-io/browser
FROM lightpanda/browser:1.0.2
COPY --from=caddy /usr/bin/caddy /usr/local/bin/caddy
COPY Caddyfile /etc/caddy/Caddyfile
COPY railway-start /usr/local/bin/railway-start
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/railway-start"]
