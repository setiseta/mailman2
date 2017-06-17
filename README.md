# mailman2
A simple container to host mailman 2 mailing lists.

This container run 
- mailman
- postfix
- crontab
    
Environments:
- MAIL_DOMAIN
- URL_HOST
- LANGUAGE (Default: en)
- MM_PASSWORD
- MM_SITEPASS
- ADMIN_EMAIL