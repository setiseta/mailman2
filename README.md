# mailman2
A simple container to host mailman 2 mailing lists.

This container run 
- mailman
- exim4
- crontab
    
Environments:
- MAIL_DOMAIN
- URL_HOST
- LANGUAGE (Default: en)
- MM_PASSWORD
- ADMIN_EMAIL